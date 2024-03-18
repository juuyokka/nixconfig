{ self, config, lib, ... }:
let
  inherit (lib)
    mapAttrsToList
    mkIf
    mkOption
    types
    ;
  inherit (self.lib)
    concatMapAttrsToList
    ;

  mappedBindSubmodule = types.submodule {
    options = {
      bindMap = mkOption {
        type = types.attrsOf types.str;
      };
      binds = mkOption {
        type = with types; attrsOf (functionTo (functionTo str));
      };
    };
  };

  mapBind = (bindMap: binds:
    (concatMapAttrsToList
      (prev: final:
        (mapAttrsToList
          (_: bind: bind final prev)
          binds))
      bindMap));

  cfg = config.milky.hyprland;
in
{
  options.milky.hyprland = {
    mappedBinds = mkOption {
      type = types.attrsOf mappedBindSubmodule;
      default = { };
    };
  };

  config = mkIf (cfg.mappedBinds != { }) {
    wayland.windowManager.hyprland = {
      settings = {
        bind = concatMapAttrsToList (_: v: mapBind v.bindMap v.binds) cfg.mappedBinds;
      };
    };
  };
}
