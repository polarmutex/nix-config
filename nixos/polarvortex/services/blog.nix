{ config, lib, pkgs, ... }:
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
        # https://securityheaders.com/
        extraConfig = ''
          add_header Strict-Transport-Security "max-age=31536000; includeSubDomains";
          add_header X-Content-Security-Policy "default-src 'self' *.brianryall.xyz";
          add_header X-Frame-Options "SAMEORIGIN";
          add_header X-Content-Type-Options "nosniff";
          add_header Permissions-Policy "interest-cohort=()";
          add_header Referrer-Policy "strict-origin-when-cross-origin";
        '';
      };
    };
  };

}
