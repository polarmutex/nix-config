{inputs, ...}: {
  flake.nixosModules.sparkyfitness-service = {
    config,
    pkgs,
    ...
  }: let
    inherit (config.networking) domain;

    host = "fitness.${domain}";
  in {
    imports = [inputs.sparkyfitness.nixosModules.sparkyfitness];

    # Systemd EnvironmentFile with:
    #   SPARKY_FITNESS_DB_PASSWORD, SPARKY_FITNESS_APP_DB_PASSWORD,
    #   SPARKY_FITNESS_API_ENCRYPTION_KEY, BETTER_AUTH_SECRET
    sops.secrets.sparkyfitnessEnv = {
      mode = "0400";
      owner = "root";
    };

    services.sparkyfitness = {
      enable = true;
      frontendUrl = "https://${host}";
      environmentFile = config.sops.secrets.sparkyfitnessEnv.path;
      # Upstream sets services.postgresql.package from this, so it pins the
      # host-wide postgres (needs >= 15).
      database.package = pkgs.postgresql_16;
      nginx.virtualHost = host;
    };

    services.nginx.virtualHosts.${host} = {
      forceSSL = true;
      enableACME = true;
      extraConfig = ''
        access_log /var/log/nginx/sparkyfitness.access.log;
      '';
    };
  };
}
