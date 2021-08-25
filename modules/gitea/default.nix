{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.polar.services.gitea;
  cfg_gitea = config.services.gitea;
  domain = config.networking.domain;
in
{

  options.polar.services.gitea = {

    enable = mkEnableOption "gitea service";

    privatePort = mkOption {
      type = types.port;
      default = 8082;
      example = 8082;
      description = "Port to serve the app";

    };
  };

  config = mkIf cfg.enable {

    users.users.git = {
      description = "Gitea Service";
      home = cfg_gitea.stateDir;
      useDefaultShell = true;
      group = "git";
      isSystemUser = true;
    };
    users.groups.git = {};

    services.gitea = {
      enable = true;
      user = "git";
      domain = "git.${domain}";
      appName = "${cfg_gitea.domain}: git in plurality";
      rootUrl = "https://${cfg_gitea.domain}/";
      httpAddress = "127.0.0.1";
      httpPort = cfg.privatePort;
      log.level = "Warn";
      lfs.enable = true;

      # NOTE: temporarily remove this for initial setup
      disableRegistration = true;

      # only send cookies via HTTPS
      cookieSecure = true;

      settings = {
        other.SHOW_FOOTER_VERSION = true;
        repository = {
          ENABLE_PUSH_CREATE_USER = true;
          DEFAULT_BRANCH = "main";
          DISABLE_HTTP_GIT = true;
        };
        ui = {
          THEMES = "arc-green";
          DEFAULT_THEME = "arc-green";
        };
      };

      # NixOS module uses `gitea dump` to backup repositories and the database,
      # but it produces a single .zip file that's not very restic friendly.
      # I configure my backup system manually below.
      dump.enable = false;
      database = {
        type = "postgres";
        # user needs to be the same as gitea user
        user = "git";
      };
    };

    services.nginx = {
      virtualHosts = {
        "git.${domain}" = {
          forceSSL = true;
          enableACME = true;
          extraConfig = ''
            access_log /var/log/nginx/gitea.access.log;
          '';

          locations."/" = {
            proxyPass = "http://127.0.0.1:${toString cfg.privatePort}";
          };
        };
      };
    };

  };
}
