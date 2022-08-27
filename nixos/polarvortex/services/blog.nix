{ config, lib, ... }:
let
  inherit (config.networking) domain;

in
{

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

}
