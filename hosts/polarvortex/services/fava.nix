{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (config.networking) domain;
  cfg = config.services.fava;

  ledgerSyncScript = pkgs.writeShellScript "ledger-sync" ''
    set -euo pipefail

    # Validate required environment variables
    if [ -z "''${GIT_SSH_URL:-}" ] || [ -z "''${GIT_BRANCH:-}" ] || [ -z "''${BEAN_FILE:-}" ]; then
      echo "Error: GIT_SSH_URL, GIT_BRANCH, and BEAN_FILE must be set"
      exit 1
    fi

    # Setup directories
    mkdir -p ${cfg.dataDir}/repo
    mkdir -p ${cfg.dataDir}/state

    # Configure Git SSH
    export GIT_SSH_COMMAND="ssh -i ${cfg.sshKeyPath} -o UserKnownHostsFile=${cfg.knownHostsPath} -o StrictHostKeyChecking=yes"

    cd ${cfg.dataDir}/repo

    # Clone or update repository
    if [ ! -d ".git" ]; then
      echo "Cloning repository..."
      ${pkgs.git}/bin/git clone --single-branch --branch "$GIT_BRANCH" "$GIT_SSH_URL" .
    else
      echo "Updating repository..."
      ${pkgs.git}/bin/git fetch --prune
      ${pkgs.git}/bin/git reset --hard "origin/$GIT_BRANCH"
    fi

    # Handle git-crypt if enabled
    ${lib.optionalString cfg.gitCrypt.enable ''
      echo "Unlocking git-crypt..."
      ${pkgs.git-crypt}/bin/git-crypt unlock ${cfg.gitCrypt.keyPath}
    ''}

    # Validate ledger file exists
    if [ ! -f "$BEAN_FILE" ]; then
      echo "Error: Ledger file $BEAN_FILE not found"
      exit 1
    fi

    # Validate beancount syntax
    # echo "Validating beancount file..."
    # ${pkgs.python3Packages.beancount}/bin/bean-check "$BEAN_FILE"

    # Record success
    date -Iseconds > ${cfg.dataDir}/state/last_sync
    echo "Sync completed successfully"
  '';
in {
  options.services.fava = {
    enable = lib.mkEnableOption "Beancount ledger with Fava web interface";

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/fava";
      description = "Directory for fava data and repository";
    };

    gitUrl = lib.mkOption {
      type = lib.types.str;
      example = "git@github.com:user/ledger.git";
      description = "SSH URL of the git repository containing the ledger";
      default="ssh://git@git.polarmutex.dev/polar/beancount.git";
    };

    gitBranch = lib.mkOption {
      type = lib.types.str;
      default = "main";
      description = "Git branch to sync";
    };

    beanFile = lib.mkOption {
      type = lib.types.str;
      example = "main.bean";
      description = "Path to the main beancount file relative to repository root";
      default="main.beancount";
    };

    sshKeyPath = lib.mkOption {
      type = lib.types.path;
      description = "Path to SSH private key for git access";
      default=  config.sops.secrets.favaSSHPrivateKey.path;
    };

    knownHostsPath = lib.mkOption {
      type = lib.types.path;
      description = "Path to SSH known_hosts file";
      default=  config.sops.secrets.favaSSHKnownHosts.path;
    };

    gitCrypt = {
      enable = lib.mkEnableOption "git-crypt decryption";

      keyPath = lib.mkOption {
        type = lib.types.path;
        description = "Path to git-crypt symmetric key";
      };
    };

    sync = {
      enable = lib.mkEnableOption "automatic ledger synchronization" // {default = true;};

      interval = lib.mkOption {
        type = lib.types.str;
        default = "daily";
        description = "Systemd calendar interval for sync (e.g., 'daily', 'hourly', '02:00')";
      };
    };

    fava = {
      enable = lib.mkEnableOption "Fava web interface" // {default = true;};

      port = lib.mkOption {
        type = lib.types.port;
        default = 5000;
        description = "Port for Fava web interface";
      };

      subdomain = lib.mkOption {
        type = lib.types.str;
        default = "fava";
        description = "Subdomain for Fava web interface";
      };

      basicAuth = {
        enable = lib.mkEnableOption "HTTP Basic Authentication";

        htpasswdFile = lib.mkOption {
          type = lib.types.path;
          description = "Path to htpasswd file for basic auth";
          default=  config.sops.secrets.favaHtPasswd.path;

        };
      };
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "fava";
      description = "User account for fava services";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "fava";
      description = "Group account for fava services";
    };
  };

  config = lib.mkIf cfg.enable {
    # Create user and group
    users.users.${cfg.user} = {
      isSystemUser = true;
      group = cfg.group;
      home = cfg.dataDir;
      createHome = true;
      description = "fava service user";
    };

    users.groups.${cfg.group} = {};

    # Ledger sync service
    systemd.services.beancount-sync = lib.mkIf cfg.sync.enable {
      description = "Sync beancount ledger from git repository";
      wants = ["network-online.target"];
      after = ["network-online.target"];

      path = [pkgs.openssh pkgs.git pkgs.git-crypt];

      environment = {
        GIT_SSH_URL = cfg.gitUrl;
        GIT_BRANCH = cfg.gitBranch;
        BEAN_FILE = cfg.beanFile;
      };

      serviceConfig = {
        Type = "oneshot";
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${ledgerSyncScript}";
        WorkingDirectory = cfg.dataDir;

        # Security hardening
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        ReadWritePaths = [cfg.dataDir];
      };
    };

    # Sync timer
    systemd.timers.beancount-sync = lib.mkIf cfg.sync.enable {
      description = "Timer for beancount ledger sync";
      wantedBy = ["timers.target"];
      timerConfig = {
        OnCalendar = cfg.sync.interval;
        Persistent = true;
      };
    };

    # Fava web service
    systemd.services.fava = lib.mkIf cfg.fava.enable {
      description = "Fava web interface";
      wants = ["beancount-sync.service" "network-online.target"];
      after = ["beancount-sync.service" "network-online.target"];
      wantedBy = ["multi-user.target"];

      path = [
        inputs.beancount-repo.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        ExecStart = ''
          ${inputs.beancount-repo.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/fava \
            --host 127.0.0.1 \
            --port ${toString cfg.fava.port} \
            ${cfg.dataDir}/repo/${cfg.beanFile}
        '';
        Restart = "on-failure";
        RestartSec = "10s";

        # Security hardening
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        ReadOnlyPaths = [cfg.dataDir];
      };
    };

    # Nginx reverse proxy with optional basic auth
    services.nginx.virtualHosts."${cfg.fava.subdomain}.${domain}" = lib.mkIf cfg.fava.enable {
      forceSSL = true;
      enableACME = true;

      # Apply basic auth at the vhost level for all requests
      basicAuthFile = lib.mkIf cfg.fava.basicAuth.enable cfg.fava.basicAuth.htpasswdFile;

      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString cfg.fava.port}";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
        '';
      };
    };
  };
}
