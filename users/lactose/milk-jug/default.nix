{ pkgs, ... }:
{
  imports = [ ./desktop ];

  milky.git.enable = true;

  milky.cursor = {
    enable = true;
    package = pkgs.milkyPackages.xcursor-pro;
    theme = "XCursor-Pro-Dark";
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  home.stateVersion = "23.11";
}
