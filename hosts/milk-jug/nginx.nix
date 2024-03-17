{ lib, config, ... }:
let
  navidrome = config.services.navidrome;
in
{
  security.acme = {
    acceptTerms = true;
    defaults.email = "yokotaniemi@protonmail.com";
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts = {
      "music.lactose.dev" = lib.mkIf navidrome.enable {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://192.168.1.110:${navidrome.settings.Port}";
        };
      };
    };
  };
}
