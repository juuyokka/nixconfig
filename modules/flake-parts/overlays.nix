{ self, inputs, ... }:
let
  inherit (inputs) hyprland hy3;

  mkOverlay = f: final: prev: f final prev prev.stdenv.hostPlatform.system;
in
{
  flake.overlays = {
    hyprland-unstable = mkOverlay (_: _: system: {
      inherit (hyprland.packages.${system})
        hyprland
        xdg-desktop-portal-hyprland
        ;
    });

    hyprland-plugins = mkOverlay (_: _: system: {
      hyprlandPlugins = {
        inherit (hy3.packages.${system}) hy3;
      };
    });

    milky-packages = mkOverlay (_: _: system: {
      milkyPackages = self.packages.${system};
    });
  };
}
