{ config, lib, ... }:
let
  cfg = config.polar.services.blog;
  inherit (config.networking) domain;

  makeHostInfo = name: {
    name = "${name}.${domain}";
    value = "/var/www/${name}";
  };
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
