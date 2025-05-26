{
  config,
  pkgs,
  ...
}: let
  cfg_gitea = config.services.gitea;
  inherit (config.networking) domain;
  port = 8082;
  theme = pkgs.fetchurl {
    url = "https://github.com/lutinglt/gitea-github-theme/releases/download/v1.23.3-20250211-1920/theme-github.css";
    sha256 = "";
    stripRoot = false;
  };
in {
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
    appName = "${domain}: git in plurality";
    # lfs.enable = true;
    # package = pkgs.unstable.gitea;

    settings = {
      #log.LEVEL = "Warn";
      server = {
        DOMAIN = "git.${domain}";
        ROOT_URL = "https://git.${domain}/";
        HTTP_PORT = port;
        HTTP_ADDR = "127.0.0.1";
      };

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
        THEMES = "gitea-dark";
        DEFAULT_THEME = "gitea-dark";
      };
      mailer = {
        ENABLED = true;
        PROTOCOL = "sendmail";
        FROM = "do-not-reply@${domain}";
        SENDMAIL_PATH = "${pkgs.system-sendmail}/bin/sendmail";
      };
    };

    # NixOS module uses `gitea dump` to backup repositories and the database,
    # but it produces a single .zip file that's not very restic friendly.
    # I configure my backup system manually below.
    # dump = {
    #   enable = true;
    #   backupDir = "/backup/gitea";
    # };
    database = {
      type = "postgres";
      # user needs to be the same as gitea user
      user = "git";
      name = "git";
    };
  };

  #systemd.tmpfiles.rules = [
  #  "z ${config.services.gitea.dump.backupDir} 750 git gitea - -"
  #  "d ${config.services.gitea.dump.backupDir} 750 git gitea - -"
  #];

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
