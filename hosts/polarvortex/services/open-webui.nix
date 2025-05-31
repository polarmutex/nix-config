{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.open-webui;
  inherit (config.networking) domain;
  port = 8085;
  port_redis = 8106;
in {
  virtualisation.oci-containers = {
    containers = {
      # open-webui = {
      #   autoStart = true;
      #   image = "ghcr.io/open-webui/open-webui:main";
      #   environment = rec {
      #     "TZ" = "US/EASTERN";
      #     # "OLLAMA_BASE_URL" = "http://host.containers.internal:${toString config.services.ollama.port}";
      #     # "OLLAMA_API_BASE_URL" = "${OLLAMA_BASE_URL}/api";
      #   };
      #   environmentFiles = [];
      #   extraOptions = [
      #     "--pull=always" # Pull if the image on the registry is always
      #     # "--network=host"
      #   ];
      #   ports = ["127.0.0.1:${toString port}:8080"];
      # };
    };
  };

  services.nginx = {
    virtualHosts = {
      # "ai.${domain}" = {
      #   forceSSL = true;
      #   enableACME = true;
      #   extraConfig = ''
      #     access_log /var/log/nginx/open-webui.access.log;
      #   '';
      #
      #   locations."/" = {
      #     proxyPass = "http://127.0.0.1:${toString port}";
      #     proxyWebsockets = true;
      #   };
      # };
    };
  };

  users.users.open-webui = {
    description = "open-webui Service";
    group = "open-webui";
    isSystemUser = true;
    home = cfg.stateDir;
    useDefaultShell = true;
  };
  users.groups.open-webui = {};

  # systemd.services.ollama.serviceConfig = {
  #   DynamicUser = lib.mkForce false;
  # };
}
