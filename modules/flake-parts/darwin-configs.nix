{ self, lib, config, inputs, ... }@args:
import ./system-configs.nix
{
  optionPath = "darwinConfigs";
  outputName = "darwinConfigurations";
  systemFunc = inputs.nix-darwin.lib.darwinSystem;
  hmModule = inputs.home-manager.darwinModules.home-manager;

  baseModule = hostname: { system, ... }: {
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    networking.hostName = hostname;
    nixpkgs.hostPlatform = system;
  };
}
  args
