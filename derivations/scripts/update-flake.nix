{ writeShellApplication, pkgs }:
writeShellApplication {
  name = "update-flake";
  runtimeInputs = with pkgs; [ gum jq ];
  excludeShellChecks = [ "SC2086" ];

  text = ''
    set -f
    flake_inputs=$(nix flake metadata --json | jq -r ".locks.nodes.root.inputs|keys[]")
    selection=$(gum choose $flake_inputs --no-limit --header "Select which inputs to update.")
    nix flake update $selection
  '';
}
