{ config, lib, pkgs, ... }:

with lib;
let
  backend = config.virtualisation.oci-containers.backend;
  inherit (config.networking) domain;

  port = 3000;
  postgresTag = "13";
  umamiTag = "postgresql-latest";
  #environmentFile = config.sops.secrets."services/umami/env".path;
in
{
  sops.secrets."services/umami/db_url" = { };

  virtualisation.oci-containers = {
    backend = "podman";
    containers = {
      umami = {
        autoStart = true;
        image = "ghcr.io/umami-software/umami:postgresql-latest";
        environment = {
          #"DATABASE_URL" = "cat ${config.sops.secrets.borg-passphrase.path}";
          #"DATABASE_TYPE" = "postgresql";
          "HASH_SALT" = "replace-me-with-a-random-string";
        };
        environmentFiles = [ config.sops.secrets."services/umami/db_url".path ];
        #extraOptions = [ "--network=umami_network" ];
        #dependsOn = [ "umami-db" ];
        ports = [ "127.0.0.1:${toString port}:3000" ];
        #extraOptions = [ "--pod=umami-pod" ];
      };
      #umami-db = {
      #  autoStart = true;
      #  image = "postgres:12-alpine";
      #  environment = {
      #    "POSTGRES_DB" = "umami";
      #    "POSTGRES_USER" = "umami";
      #    "POSTGRES_PASSWORD" = "umami";
      #  };
      #  #extraOptions = [ "--network=umami_network" ];
      #  volumes = [ "/home/polar/pgdata:/var/lib/postgresql/data" ];
      #  extraOptions = [ "--pod=umami-pod" ];
      #};
    };
  };
  #systemd.services.create-umami-pod = {
  #  serviceConfig.Type = "oneshot";
  #  wantedBy = [
  #    "podman-umami.service"
  #    "podman-umami-db.service"
  #  ];
  #  script = with pkgs; ''
  #    ${podman}/bin/podman pod exists umami-pod || \
  #      ${podman}/bin/podman pod create --name umami-pod -p '0.0.0.0:3000:3000 --network bridge'
  #  '';
  #};
  systemd.services."${backend}-umami".preStart = "${backend} network create -d bridge umami_network || true";

  services.nginx = {
    virtualHosts = {
      "umami.${domain}" = {
        forceSSL = true;
        enableACME = true;
        extraConfig = ''
          access_log /var/log/nginx/umami.access.log;
        '';

        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString port}";
        };
      };
    };
  };

  #services.backups.scripts.umami = ''
  #  ${backend} exec -i umami-db pg_dump -U umami --no-owner umami | gzip -9 > dump.sql.gz
  #'';
}
