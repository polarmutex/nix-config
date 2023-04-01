{
  config,
  pkgs,
  ...
}: let
  inherit (config.networking) domain;
  port = 4000;
in {
  environment.systemPackages = [pkgs.website];

  systemd.services.website = {
    description = "my website";
    after = ["network.target"];
    wantedBy = ["multi-user.target"];

    serviceConfig = {
      Type = "simple";
      User = "website";
      Group = "website";
      WorkingDirectory = "${pkgs.website}";
      ExecStart = "${pkgs.website}/target/server/release/brianryall-xyz";
      Restart = "always";
      # Security
      NoNewPrivileges = true;
      # Sandboxing
      PrivateDevices = true;
      ProtectHome = true;
      ProtectSystem = true;
      PrivateTmp = true;
      PrivateUsers = true;
      ProtectHostname = true;
      ProtectClock = true;
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectKernelLogs = true;
      ProtectControlGroups = true;
      #RestrictAddressFamilies = ["AF_UNIX AF_INET AF_INET6"];
      #LockPersonality = true;
      #MemoryDenyWriteExecute = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      PrivateMounts = true;
      # System Call Filtering
      SystemCallArchitectures = "native";
      SystemCallFilter = [
        "~@reboot"
        "@module"
        "@mount"
        "@swap"
        "@resources"
        "@cpu-emulation"
        "@obsolete"
        "@debug"
        "~@privileged"
      ];
    };

    environment = {
      LEPTOS_OUTPUT_NAME = "true";
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
        #root = "${pkgs.website}";
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
