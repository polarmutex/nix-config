{
  config,
  inputs,
  pkgs,
  ...
}: let
  inherit (config.networking) domain;
  port = 4000;
  websiteTag = "0.1.2";
in {
  virtualisation.oci-containers = {
    containers = {
      website = {
        autoStart = true;
        image = "ghcr.io/polarmutex/website/site-server:${websiteTag}";
        environment = {
        };
        environmentFiles = [];
        # extraOptions = ["--network=host"];
        ports = ["127.0.0.1:${toString port}:3000"];
      };
    };
  };

  users.users.website = {
    description = "Website Service";
    #home = cfg.stateDir;
    useDefaultShell = true;
    group = "website";
    isSystemUser = true;
  };

  users.groups.website = {};

  services.nginx = {
    enable = true;

    virtualHosts = {
      "${domain}" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString port}";
          proxyWebsockets = true;
        };
        # https://securityheaders.com/
        #extraConfig = ''
        #  add_header Strict-Transport-Security "max-age=31536000; includeSubDomains";
        #  add_header X-Content-Security-Policy "default-src 'self' *.brianryall.xyz";
        #  add_header X-Frame-Options "SAMEORIGIN";
        #  add_header X-Content-Type-Options "nosniff";
        #  add_header Permissions-Policy "interest-cohort=()";
        #  add_header Referrer-Policy "strict-origin-when-cross-origin";
        #'';
      };
    };
  };
}
