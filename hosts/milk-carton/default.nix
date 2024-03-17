{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  services.nix-daemon.enable = true;
  programs.zsh.enable = true;

  networking.computerName = "Milk Carton";

  users.users.lactose = {
    home = "/Users/lactose";
  };

  system.defaults.NSGlobalDomain = {
    NSAutomaticCapitalizationEnabled = false;
    NSAutomaticSpellingCorrectionEnabled = false;
    NSAutomaticPeriodSubstitutionEnabled = false;
  };

  system.stateVersion = 4;
}
