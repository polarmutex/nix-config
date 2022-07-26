{ config, lib, ... }:
let
  cfg = config.polar.services.blog;
  inherit (config.networking) domain;

in
{
  options.polar.services.blog = {
    enable = lib.mkEnableOption "Blog hosting";
  };

  config = lib.mkIf cfg.enable {

    services.nginx = {
      enable = true;

      virtualHosts = {
        "${domain}" = {
          forceSSL = true;
          enableACME = true;
          root = "/var/www/blog";
        };
      };
    };

  };
}
