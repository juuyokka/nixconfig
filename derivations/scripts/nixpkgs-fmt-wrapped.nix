{ writeShellApplication, nixpkgs-fmt }:
writeShellApplication {
  name = "nixpkgs-fmt-wrapped";
  runtimeInputs = [ nixpkgs-fmt ];
  text = ''
    if [ "$1" = "." ]
    then
      find . -not \( -path "./lib" -prune \) -type f -name "*.nix" -print0 | xargs -0 nixpkgs-fmt
    else
      nixpkgs-fmt "$@"
    fi
  '';
}
