{ self, lib, config, inputs, ... }:
let
  inherit (lib)
    mkOption
    types
    ;
in
{
  options = {
    packages = mkOption {
      type = types.attrsOf (types.submodule {
        options = {
          path = mkOption {
            type = types.path;
          };
          args = mkOption {
            type = types.attrs;
            default = { };
          };
          system = mkOption {
            type = types.str;
            default = "";
          };
          nixpkgs = mkOption {
            type = types.package;
            default = inputs.nixpkgs;
          };
        };
      });
      default = { };
    };
  };

  config.flake.packages = self.lib.mapListToAttrs
    (hostSystem:
      let
        mkPackage = _: { path, args, system, nixpkgs }:
          let pkgs = import nixpkgs { system = hostSystem; };
          in pkgs.callPackage path args;

        matchingSystemPredicate = _: { system, ... }: lib.hasSuffix system hostSystem;

        packages' = lib.filterAttrs matchingSystemPredicate config.packages;
      in
      lib.mapAttrs mkPackage packages')
    config.systems;
}
