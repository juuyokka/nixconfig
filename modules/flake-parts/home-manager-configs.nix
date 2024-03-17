{ self, lib, config, inputs, ... }:
let
  inherit (lib)
    mkOption
    types
    ;

  cfg = config.homeConfigs;
in
{
  options = {
    homeConfigs =
      let
        modulesType = types.listOf types.deferredModule;
        configSubmodule = types.submodule {
          options = {
            system = mkOption {
              type = types.nullOr types.str;
              default = null;
            };
            modules = mkOption {
              type = modulesType;
              default = [ ];
            };
          };
        };
      in
      {
        commonModules = mkOption {
          type = modulesType;
          default = [ ];
        };
        configs = mkOption {
          type = types.nullOr (types.attrsOf configSubmodule);
          default = null;
        };
      };
  };

  config = {
    flake = {
      homeConfigurations = lib.mkIf (cfg.configs != null)
        (lib.mapAttrs
          (name: { system, modules }:
            let
              specialArgs = { inherit self inputs; };

              hostname = lib.last (lib.splitString "@" name);
              machines = config.nixosConfigs.configs // config.darwinConfigs.configs;

              system' = if system != null then system else machines.${hostname}.system;
              isLinux = lib.hasSuffix "-linux" system';
            in
            inputs.home-manager.lib.homeManagerConfiguration {
              pkgs = import (if isLinux then inputs.nixpkgs else inputs.nixpkgs-darwin)
                { system = system'; };
              extraSpecialArgs = specialArgs;

              modules = cfg.commonModules ++ modules;
            }
          )
          cfg.configs);
    };
  };
}
