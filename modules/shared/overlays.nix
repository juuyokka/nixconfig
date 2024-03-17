{ self, lib, config, pkgs, inputs, ... }:
let
  inherit (lib)
    mkOption
    types
    ;

  cfg = config.milky.overlays;

  defaultEnabled = [ "milky-packages" ];
in
{
  options.milky.overlays = lib.mapAttrs
    (name: _: {
      enable = mkOption {
        type = types.bool;
        default = builtins.elem name defaultEnabled;
        example = true;
        description = "Whether to enable ${name} overlay.";
      };
    })
    self.overlays;

  config.nixpkgs.overlays = (lib.mapAttrsToList
    (name: lib.mkIf cfg.${name}.enable)
    self.overlays);
}
