{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.polar.services.miniflux;
  domain = config.networking.domain;
in
{

  options.polar.services.miniflux = {
    enable = mkEnableOption "miniflux RSS reader";
  };

  config = mkIf cfg.enable {

    services.nginx = {
      enable = true;

      virtualHosts = {

        # The Lounge IRC
        "rss.${domain}" = {
          forceSSL = true;
          enableACME = true;
          locations."/" = { proxyPass = "http://127.0.0.1:8787"; };
        };
      };
    };

    services.miniflux = {
      enable = true;
      config = {
        CLEANUP_FREQUENCY = "48";
        LISTEN_ADDR = "127.0.0.1:8787";
      };
      adminCredentialsFile = "/var/src/machine-config/.secrets/miniflux/credentials";

    };
  };
}
