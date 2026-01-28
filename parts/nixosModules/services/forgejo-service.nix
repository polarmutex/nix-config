{
  flake.nixosModules.forgejo-service = {
    config,
    lib,
    pkgs,
    ...
  }: let
    inherit (config.networking) domain;
    cfg = config.services.forgejo;
    srv = cfg.settings.server;
    woodpecker-server = "ci.${domain}";
    # theme = pkgs.fetchurl {
    #   url = "https://github.com/lutinglt/gitea-github-theme/releases/download/v1.23.3-20250211-1920/theme-github.css";
    #   sha256 = "";
    #   stripRoot = false;
    # };
  in {
    users.users.git = {
      description = "Gitea Service";
      home = cfg.stateDir;
      useDefaultShell = true;
      group = "git";
      isSystemUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHuX4iAlw/LZdhLOZjGu7leM8Y/Nu/27VrXaDR1ogg2s polar@polarbear"
      ];
    };
    users.groups.git = {};

    #systemd.tmpfiles.rules = [
    #  "z ${config.services.gitea.dump.backupDir} 750 git gitea - -"
    #  "d ${config.services.gitea.dump.backupDir} 750 git gitea - -"
    #];

    services.nginx = {
      virtualHosts = {
        ${cfg.settings.server.DOMAIN} = {
          extraConfig = ''
            client_max_body_size 512M;
          '';
          forceSSL = true;
          http3 = true;
          http3_hq = true;
          kTLS = true;
          # quic = true;
          enableACME = true;
          locations."/".proxyPass = "http://localhost:${toString srv.HTTP_PORT}";
        };
      };
    };

    services = {
      forgejo = {
        enable = true;
        user = "git";
        lfs.enable = true;
        package = pkgs.unstable.forgejo;
        settings = {
          actions.ENABLED = true;
          DEFAULT = {
            APP_NAME = "PolarMutex's Git forge";
            APP_SLOGAN = "The place where polars forge their code";
          };
          mailer = {
            ENABLED = false;
            # FROM = "noreply@brianryall.xyz";
            # PASSWD = config.sops.secrets."mail/forgejo".path;
            # SMTP_ADDR = "mail.xxx.xyz";
            # USER = "noreply@brianryall.xyz";
          };
          other = {
            SHOW_FOOTER_VERSION = true;
          };
          server = {
            DOMAIN = "git.${domain}";
            HTTP_PORT = 3050;
            ROOT_URL = "https://${srv.DOMAIN}/";
            SSH_DOMAIN = "git.${domain}";
            SSH_PORT = 22;
          };
          service.DISABLE_REGISTRATION = true;
          session.COOKIE_SECURE = true;
          ui = {
            # DEFAULT_THEME = "catppuccin-maroon-auto";
            # THEMES = "catppuccin-rosewater-auto,catppuccin-flamingo-auto,catppuccin-pink-auto,catppuccin-mauve-auto,catppuccin-red-auto,catppuccin-maroon-auto,catppuccin-peach-auto,catppuccin-yellow-auto,catppuccin-green-auto,catppuccin-teal-auto,catppuccin-sky-auto,catppuccin-sapphire-auto,catppuccin-blue-auto,catppuccin-lavender-auto";
          };
        };
        database = {
          user = "git";
          name = "git";
          type = "postgres";
        };
      };

      # Link Catppuccin themes and ensure admin user
      # Woodpecker CI/CD, just because why not?
      # woodpecker-server = {
      #   enable = true;
      #   environment = {
      #     WOODPECKER_FORGEJO = "true";
      #     WOODPECKER_FORGEJO_URL = "https://git.dr460nf1r3.org";
      #     WOODPECKER_HOST = "https://${woodpecker-server}";
      #     WOODPECKER_OPEN = "true";
      #     WOODPECKER_SERVER_ADDR = ":3007";
      #   };
      #   environmentFile = config.sops.secrets."env/woodpecker".path;
      # };
      #
      # woodpecker-agents.agents."docker" = {
      #   enable = true;
      #   extraGroups = ["podman"];
      #   environment = {
      #     DOCKER_HOST = "unix:///run/podman/podman.sock";
      #     WOODPECKER_BACKEND = "docker";
      #     WOODPECKER_MAX_WORKFLOWS = "4";
      #     WOODPECKER_SERVER = "localhost:9000";
      #   };
      #   environmentFile = [config.sops.secrets."env/woodpecker".path];
      # };
    };

    systemd.services.forgejo.preStart = let
      adminCmd = "${lib.getExe cfg.package} admin user";
      pwd = config.sops.secrets."passwords/forgejo";
      user = "polar";
    in ''
      ${adminCmd} create --admin --email "root@localhost" --username ${user} --password "$(tr -d '\n' < ${pwd.path})" || true
      # ${adminCmd} change-password --username ${user} --password "$(tr -d '\n' < ${pwd.path})" || true
    '';
    # rm -rf ${config.services.forgejo.stateDir}/custom/public/assets
    # mkdir -p ${config.services.forgejo.stateDir}/custom/public/assets
    # ln -sf ${theme} ${config.services.forgejo.stateDir}/custom/public/assets/css

    sops.secrets."passwords/forgejo" = {
      mode = "0400";
      owner = config.users.users.git.name;
      path = "/var/lib/forgejo/.password";
    };

    # sops.secrets."env/woodpecker" = {
    #   mode = "0400";
    #   owner = config.users.users.root.name;
    #   path = "/var/lib/woodpecker/.env";
    # };
  };
}
