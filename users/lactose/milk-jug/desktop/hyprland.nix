{ self, lib, pkgs, ... }:
let
  inherit (lib)
    flip
    mod
    nameValuePair
    range
    zipListsWith
    ;
  inherit (self.lib)
    compose
    ;

  wsRange = range 1 10;
  workspaces = map toString wsRange;
  workspaceKeys = map (compose toString (flip mod 10)) wsRange;

  # { "10" = "0"; "1" = "1"; "2" = "2"; "3" = "3"; ... }
  workspaceBindMap = builtins.listToAttrs (zipListsWith nameValuePair workspaceKeys workspaces);

  md = "SUPER";
in
{
  imports = [
    ./firefox.nix
    ./foot.nix
  ];

  milky.hyprland = {
    enable = true;
    mappedBinds = {
      "window navigation" = {
        binds = {
          "move focus" = f: p: "${md},${p},movefocus,${f}";
          "move window" = f: p: "${md}+SHIFT,${p},movewindow,${f}";
        };
        bindMap = { "H" = "l"; "J" = "d"; "K" = "u"; "L" = "r"; };
      };
      "workspace navigation" = {
        binds = {
          "switch workspace" = f: p: "${md},${p},workspace,${f}";
          "move window" = f: p: "${md}+SHIFT,${p},movetoworkspacesilent,${f}";
          "move window and switch" = f: p: "${md}+CTRL,${p},movetoworkspace,${f}";
        };
        bindMap = workspaceBindMap;
      };
    };
  };

  wayland.windowManager.hyprland = {
    settings = {
      bind = [
        "${md},RETURN,exec,foot"
        "${md}+SHIFT,Q,killactive"
        "${md},W,exec,firefox"
        "${md}+SHIFT,E,exit"

        "${md},F,fullscreen"
        "${md}+CTRL,F,fakefullscreen"
      ];

      general.layout = "master";
      input.natural_scroll = true;

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        force_default_wallpaper = 0;
        enable_swallow = true;
        swallow_regex = "^foot(client)?$";
      };
    };
  };

  xdg.portal = {
    enable = true;

    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];

    configPackages = [ pkgs.hyprland ];
  };
}
