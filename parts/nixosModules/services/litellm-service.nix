{
  flake.nixosModules.litellm-service = {
    config,
    pkgs,
    ...
  }: let
    # inherit (config.virtualisation.oci-containers) backend;
    inherit (config.networking) domain;
    cfg = config.services.litellm;

    port = 4000;
  in {
    virtualisation.oci-containers.containers = {
      litellm = {
        extraOptions = [
          "--pull=always"
          # Using host network to access PostgreSQL Unix socket
          # Bridge networking would require PostgreSQL to listen on TCP
          "--network=host"
        ];
        image = "ghcr.io/berriai/litellm:main-stable";
        # Note: Cannot use port mapping with --network=host
        # ports = ["127.0.0.1:${builtins.toString port}:4000"];
        environment = {
          DATABASE_URL = "postgresql://litellm@localhost:5432/litellm?host=/run/postgresql";
          STORE_MODEL_IN_DB = "True"; # allows adding models to proxy via UI
        };
        environmentFiles = [config.sops.secrets.liteLLMAppSecret.path];
        volumes = [
          "/run/postgresql:/run/postgresql:ro"
        ];
      };
    };
    services = {
      # litellm = {
      #   enable = true;
      #   host = "0.0.0.0";
      #   port = port;
      #
      #   environmentFile = config.sops.secrets.liteLLMAppSecret.path;
      #   openFirewall = false;
      #   environment = {
      #     # DATABASE_URL = "postgresql:///litellm?host=/run/postgresql";
      #   };
      #   settings = {
      #     model_list = [];
      #   };
      # };
      postgresql = {
        authentication = ''
          local litellm litellm ident map=lllm
        '';
        identMap = ''
          lllm root litellm
        '';
        ensureDatabases = ["litellm"];
        ensureUsers = [
          {
            name = "litellm";
            ensureDBOwnership = true;
          }
        ];
      };
    };

    systemd.services.podman-litellm = {
      after = ["postgresql.service"];
      requires = ["postgresql.service"];
    };

    users.users.litellm = {
      description = "litellm Service";
      group = "litellm";
      isSystemUser = true;
      home = cfg.stateDir;
      useDefaultShell = true;
    };
    users.groups.litellm = {};

    services.nginx = {
      virtualHosts = {
        "litellm.${domain}" = {
          forceSSL = true;
          enableACME = true;
          # extraConfig = ''
          #   access_log /var/log/nginx/umami.access.log;
          # '';

          locations."/" = {
            proxyPass = "http://127.0.0.1:${toString port}";
          };
        };
      };
    };
  };
}
