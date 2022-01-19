{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.polar.services.rss-bridge;
  inherit (config.networking) domain;
in
{

  options.polar.services.rss-bridge = {
    enable = mkEnableOption "RSS Bridge";
  };

  config = mkIf cfg.enable {

    services.nginx = {
      virtualHosts = {
        # The Lounge IRC
        "rss-bridge.${domain}" = {
          forceSSL = true;
          enableACME = true;
        };
      };
    };

    services.rss-bridge = {
      enable = true;
      whitelist = [ "*" ];
      virtualHost = "rss-bridge.${domain}";

    };
  };
}
