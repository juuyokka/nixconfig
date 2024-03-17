{
  description = "test flake using flake-parts";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-23.11-darwin";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs-darwin";

    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko/72818e54ec29427f8d9f9cfa6fc859d01ca6dc66";

    hyprland.url = "github:hyprwm/Hyprland";

    hy3.url = "github:outfoxxed/hy3";
    hy3.inputs.hyprland.follows = "hyprland";
  };

  outputs = inputs@{ self, nixpkgs, flake-parts, ... }:
    let
      isLinux = lib.hasSuffix "-linux";
      inherit (nixpkgs) lib;
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = map (p: ./modules/flake-parts + "/${baseNameOf p}") [
        ./nixos-configs.nix
        ./darwin-configs.nix
        ./home-manager-configs.nix
        ./lib.nix
        ./overlays.nix
        ./packages.nix
      ];

      systems = [ "aarch64-darwin" "aarch64-linux" "x86_64-darwin" "x86_64-linux" ];

      nixosConfigs = {
        commonModules = [ inputs.disko.nixosModules.disko ./modules/nixos ];
        configs = {
          "milk-jug" = { modules = [ ./hosts/milk-jug ]; };
          "ubre-blanca" = { modules = [ ./hosts/ubre-blanca ]; };
        };
      };

      darwinConfigs = {
        commonModules = [ ./modules/darwin ];
        configs = {
          "milk-carton" = {
            system = "aarch64-darwin";
            modules = [ ./hosts/milk-carton ];
          };
        };
      };

      homeConfigs = {
        configs = {
          "lactose@milk-jug" = {
            modules = [
              ./modules/home/linux
              ./users/lactose/milk-jug
            ];
          };
          "lactose@milk-carton" = {
            modules = [
              ./modules/home/darwin
              ./users/lactose/milk-carton
            ];
          };
        };
      };

      packages = {
        xcursor-pro = {
          path = ./derivations/packages/xcursor-pro.nix;
          system = "linux";
        };
      };

      perSystem = { pkgs, system, ... }:
        let
          disko = inputs.disko.packages.${system}.disko;
        in
        {
          formatter = pkgs.callPackage ./derivations/scripts/nixpkgs-fmt-wrapped.nix { };

          apps = {
            update.program = pkgs.callPackage ./derivations/scripts/update-flake.nix { };
            disko.program = pkgs.callPackage ./derivations/scripts/disko-wrapped.nix
              (lib.optionalAttrs (isLinux system) { inherit disko; });
          };

          devShells = {
            default = pkgs.mkShell {
              packages = with pkgs; [ ] ++ lib.optional (isLinux system) disko;
            };
          };
        };
    };
}
