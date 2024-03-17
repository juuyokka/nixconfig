{ config, pkgs, ... }:
{
  imports = [
    ./hardware.nix
    ./disko.nix
    ./music
  ];

  milky.overlays = {
    hyprland-unstable.enable = true;
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Setup users.
  users.users.lactose = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  environment.etc."wireplumber/51-disable-webcam-mic.lua".source = ./51-disable-webcam-mic.lua;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_TIME = "en_CA.UTF-8";
  };

  services.xserver = {
    enable = true;
    layout = "us";
    xkbVariant = "";
    displayManager.lightdm.enable = false;
  };

  boot.kernelPackages = pkgs.linuxPackages_zen;

  programs.dconf.enable = true;
  programs.git.enable = true;
  security.rtkit.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
