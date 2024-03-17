{ self, lib, config, inputs, ... }@args:
import ./system-configs.nix
{
  optionPath = "nixosConfigs";
  outputName = "nixosConfigurations";
  systemFunc = inputs.nixpkgs.lib.nixosSystem;
  hmModule = inputs.home-manager.nixosModules.home-manager;

  baseModule = hostname: { system, ... }: {
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    networking.hostName = hostname;
    nixpkgs.hostPlatform = system;
  };
}
  args
