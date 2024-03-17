{ lib, stdenv, writeShellApplication, disko ? null }:
let
  inherit (stdenv.hostPlatform) system;
  isSupported = disko != null;
in
writeShellApplication {
  name = "disko-wrapped";
  runtimeInputs = lib.optional isSupported disko;

  text =
    if !isSupported
    then ''
      echo "This script does not support your system (${system})."
      exit 1
    ''
    else ''
      modprobe dm-cache
      disko "$@"
    '';
}
