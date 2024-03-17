{ baseModule ? null, hmModule ? null, optionPath, outputName, systemFunc }:
{ self, lib, config, inputs, ... }:
let
  inherit (lib)
    mkOption
    types
    ;

  splitPath = lib.splitString "." optionPath;
  cfg = lib.getAttrFromPath splitPath config;
in
{
  options = lib.setAttrByPath splitPath (
    let
      modulesType = types.listOf types.deferredModule;
      configSubmodule = {
        options = {
          system = mkOption {
            type = types.str;
            default = "x86_64-linux";
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
        type = types.nullOr (types.attrsOf (types.submodule configSubmodule));
        default = null;
      };
    }
  );

  config = {
    flake = {
      ${outputName} = lib.mkIf (cfg.configs != null)
        (lib.mapAttrs
          (hostname: { system, modules }@args:
            let
              specialArgs = { inherit self inputs; };
              intendedHost = host: user: lib.hasSuffix "@${host}" user;
            in
            systemFunc {
              inherit system specialArgs;

              modules =
                let
                  mkHomeManagerUserModule = name: userConfig:
                    let username = builtins.head (lib.splitString "@" name);
                    in lib.mkIf (intendedHost hostname name) {
                      home-manager.users.${username} = {
                        imports = config.homeConfigs.commonModules ++ userConfig.modules;
                      };
                    };

                  hmSystemModules = [
                    hmModule
                    {
                      home-manager.useGlobalPkgs = true;
                      home-manager.useUserPackages = true;
                      home-manager.extraSpecialArgs = specialArgs;
                    }
                  ];

                  hmModules = lib.mapAttrsToList mkHomeManagerUserModule config.homeConfigs.configs;
                in
                lib.optional (baseModule != null) (baseModule hostname args)
                ++ lib.optionals (hmModule != null) (hmSystemModules ++ hmModules)
                ++ cfg.commonModules
                ++ modules
              ;
            }
          )
          cfg.configs);
    };
  };
}
