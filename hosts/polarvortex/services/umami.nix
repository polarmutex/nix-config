{config, ...}: let
  inherit (config.virtualisation.oci-containers) backend;
  inherit (config.networking) domain;

  port = 3000;
  umamiTag = "postgresql-latest";
in {
  virtualisation.oci-containers = {
    backend = "podman";
    containers = {
      umami = {
        autoStart = true;
        image = "ghcr.io/umami-software/umami:${umamiTag}";
        environment = {
          "DATABASE_URL" = "postgres://umami:umami@localhost:${toString config.services.postgresql.settings.port}/umami";
        };
        environmentFiles = [];
        # ports = [
        #   {
        #     host = port;
        #     inner = 3000;
        #   }
        # ];
        extraOptions = ["--network=host"];
        #dependsOn = ["umami-db"];
      };
      #umami-db = {
      #  autoStart = true;
      #  image = "postgres:${postgresTag}";
      #  environment = {
      #    "POSTGRES_DB" = "umami";
      #    "POSTGRES_USER" = "umami";
      #    "POSTGRES_PASSWORD" = "umami";
      #  };
      #  extraOptions = ["--network=umami_network"];
      #  volumes = ["/home/polar/pgdata/umami:/var/lib/postgresql/data"];
      #  #extraOptions = ["--pod=umami-pod"];
      #};
    };
  };

  services.postgresql = {
    ensureDatabases = ["umami"];
    ensureUsers =
      builtins.map
      (
        database: {
          name = database;
          ensureDBOwnership = true;
        }
      )
      ["umami"];
  };

  # systemd.services."${backend}-umami-db".preStart = "${backend} network create -d bridge umami_network || true";

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
