{ pkgs, ... }:
let
  myNerdFonts = pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; };
in
{
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    myNerdFonts
  ];
}
