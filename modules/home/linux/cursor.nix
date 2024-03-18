{ config, lib, pkgs, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
  cfg = config.milky.cursor;
in
{
  options.milky.cursor = {
    enable = mkEnableOption "cursor";

    package = mkOption {
      type = types.package;
    };

    theme = mkOption {
      type = types.str;
    };

    size = mkOption {
      type = types.int;
      default = 24;
    };
  };

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.extraConfig = ''
      exec-once = hyprctl setcursor ${cfg.theme} ${builtins.toString cfg.size}
    '';

    home.pointerCursor = {
      gtk.enable = true;
      size = lib.mkForce cfg.size;
      x11.defaultCursor = lib.mkForce cfg.theme;
      x11.enable = true;
      name = lib.mkForce cfg.theme;
      package = lib.mkForce cfg.package;
    };

    home.sessionVariables = {
      XCURSOR_SIZE = "${builtins.toString cfg.size}";
    };

    gtk = {
      enable = true;
      cursorTheme.name = cfg.theme;
      cursorTheme.size = cfg.size;
      cursorTheme.package = cfg.package;
    };
  };
}
