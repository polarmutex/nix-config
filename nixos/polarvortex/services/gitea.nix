{ config, pkgs, lib, ... }:
let
  cfg_gitea = config.services.gitea;
  inherit (config.networking) domain;
  port = 8082;
in
{
  users.users.git = {
    description = "Gitea Service";
    home = cfg_gitea.stateDir;
    useDefaultShell = true;
    group = "git";
    isSystemUser = true;
  };
  users.groups.git = { };

  services.gitea = {
    enable = true;
    user = "git";
    domain = "git.${domain}";
    appName = "${cfg_gitea.domain}: git in plurality";
    rootUrl = "https://${cfg_gitea.domain}/";
    httpAddress = "127.0.0.1";
    httpPort = port;
    lfs.enable = true;



    settings = {
      log.LEVEL = "Warn";
      service = {
        # NOTE: temporarily remove this for initial setup
        DISABLE_REGISTRATION = true;
      };
      session = {
        # only send cookies via HTTPS
        COOKIE_SECURE = true;
      };
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
      mailer = {
        ENABLED = true;
        MAILER_TYPE = "sendmail";
        FROM = "do-not-reply@${domain}";
        SENDMAIL_PATH = "${pkgs.system-sendmail}/bin/sendmail";
      };
    };

    # NixOS module uses `gitea dump` to backup repositories and the database,
    # but it produces a single .zip file that's not very restic friendly.
    # I configure my backup system manually below.
    dump = {
      enable = true;
      backupDir = "/backup/gitea";
    };
    database = {
      type = "postgres";
      # user needs to be the same as gitea user
      user = "git";
    };
  };

  systemd.tmpfiles.rules = [
    "z ${config.services.gitea.dump.backupDir} 750 git gitea - -"
    "d ${config.services.gitea.dump.backupDir} 750 git gitea - -"
  ];

  services.nginx = {
    virtualHosts = {
      "git.${domain}" = {
        forceSSL = true;
        enableACME = true;
        extraConfig = ''
          access_log /var/log/nginx/gitea.access.log;
        '';

        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString port}";
        };
      };
    };
  };
}
