{
  lib,
  config,
  inputs,
  self,
  withSystem,
  ...
}: let
  flakeCfg = config;
  sources = import ../../../npins;
  evalConfig = import "${sources.nixpkgs}/nixos/lib/eval-config.nix";
  system = "x86_64-linux";
in {
  flake.nixosConfigurations.greyhavens = evalConfig {
    inherit system;
    pkgs = withSystem system ({pkgs, ...}: pkgs);
    modules = [
      {
        _module.args = {
          inherit inputs;
          self' = withSystem system ({self', ...}: self');
        };
      }
      self.nixosModules.host-greyhavens
      inputs.sops-nix.nixosModules.sops
      inputs.noshell.nixosModules.default
      (import sources.nix-maid).nixosModules.default
      {
        programs.noshell.enable = true;
      }
    ];
  };

  flake.nixosModules.host-greyhavens = {
    pkgs,
    config,
    inputs,
    ...
  }: {
    imports = [
      # self.nixosModules.core
      self.nixosModules.doas
      self.nixosModules.nix
      self.nixosModules.openssh
      # self.nixosModules.kernel-hardening
      # self.nixosModules.server
      # services
      # self.nixosModules.website
      # self.nixosModules.blog-service
      # self.nixosModules.fava-service
      # self.nixosModules.forgejo-service
      # self.nixosModules.hermes-agent-service
      # self.nixosModules.litellm-service
      # self.nixosModules.miniflux-service
      # self.nixosModules.paperclip-service
      # self.nixosModules.obsidian-xvfb-service
      # self.nixosModules.security-monitoring
      # self.nixosModules.sparkyfitness-service
      # self.nixosModules.tailscale
      # self.nixosModules.syncthing
      # self.nixosModules.umami-service
      # self.nixosModules.rex
      # apps
      # self.nixosModules.claude
      # self.nixosModules.claude-desktop
      # flakeCfg.flake.wrappers.claude-code-daily-log.install
    ];

    # Disable documentation building to avoid missing path errors during remote builds
    # documentation.nixos.enable = lib.mkForce false;
    # documentation.nixos.options.warningsAreErrors = false;

    environment = {
      shells = lib.mkForce (with pkgs; [bash zsh]);

      systemPackages = with pkgs; [
        neovim
        unstable.dix
        git-polar
        inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.herdr
        inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.herdr-core

        # One-time PG14 -> PG16 migration (umami, litellm) before enabling
        # sparkyfitness-service. Remove once the upgrade is done.
        # (let
        #   newPostgres = pkgs.postgresql_16;
        #   cfg = config.services.postgresql;
        #   runuser = "${pkgs.util-linux}/bin/runuser -u postgres --";
        # in
        #   pkgs.writeShellScriptBin "upgrade-pg-cluster" ''
        #     set -eux
        #     systemctl stop postgresql
        #     export NEWDATA="/var/lib/postgresql/${newPostgres.psqlSchema}"
        #     export NEWBIN="${newPostgres}/bin"
        #     export OLDDATA="${cfg.dataDir}"
        #     export OLDBIN="${cfg.finalPackage}/bin"
        #     install -d -m 0700 -o postgres -g postgres "$NEWDATA"
        #     cd "$NEWDATA"
        #     ${runuser} "$NEWBIN/initdb" -D "$NEWDATA" ${lib.escapeShellArgs cfg.initdbArgs}
        #     ${runuser} "$NEWBIN/pg_upgrade" \
        #       --old-datadir "$OLDDATA" --new-datadir "$NEWDATA" \
        #       --old-bindir "$OLDBIN" --new-bindir "$NEWBIN" \
        #       "$@"
        #   '')
        #
      ];
    };

    networking = {
      hostName = "greyhavens";
      firewall.interfaces."tailscale0".allowedTCPPorts = [9119 9871];
    };

    services = {
      # claude-desktop.claudeCodePackage = config.wrappers.claude-code-polar.wrapper;

      tailscale.authKeyFile = config.sops.secrets.tailscaleAuthKey.path;
    };

    sops = {
      # This will add secrets.yml to the nix store
      # You can avoid this by adding a string to the full path instead, i.e.
      # sops.defaultSopsFile = "/root/.sops/secrets/example.yaml";
      defaultSopsFile = ./secrets.yaml;
      age = {
        # This will automatically import SSH keys as age keys
        sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
        # This is using an age key that is expected to already be in the filesystem
        keyFile = "/var/lib/sops-nix/key.txt";
        # This will generate a new key if the key specified above does not exist
        generateKey = true;
      };
      # This is the actual specification of the secrets.
      # sops.secrets.example-key = {};
      # sops.secrets."myservice/my_subdir/my_secret" = {};
      secrets = {
        # liteLLMAppSecret = {
        #   mode = "444";
        #   group = "wheel";
        #   owner = "litellm";
        # };
        # umamiAppSecret = {
        #   mode = "444";
        #   group = "wheel";
        #   owner = "root";
        # };
        # openWebUiAppSecret = {
        #   mode = "444";
        #   group = "wheel";
        #   owner = "open-webui";
        # };
        # favaSSHPrivateKey = {
        #   mode = "0400";
        #   owner = "fava";
        # };
        # favaSSHKnownHosts = {
        #   mode = "0400";
        #   owner = "fava";
        # };
        # favaHtPasswd = {
        #   mode = "0400";
        #   owner = "nginx";
        # };
        # githubAuth = {
        #   mode = "0400";
        #   owner = "root";
        # };

        # telegramBotToken = {
        #   mode = "0400";
        #   owner = "polar";
        # };
        # morgenApiToken = {
        #   mode = "0400";
        #   owner = "polar";
        # };
        # minifluxCredentials = {
        #   mode = "0400";
        #   owner = "root";
        # };
        tailscaleAuthKey = {
          mode = "0400";
          owner = "root";
        };
        # healthImportToken = {
        #   mode = "0400";
        #   owner = "polar";
        # };
        # syncthingKey = {
        #   mode = "0400";
        #   owner = "polar";
        # };
      };
    };

    # Interactive config lives in polar's ~/.zshrc (maidModules.zsh); keep the
    # system zshrc from running its own compinit and prompt.
    programs.zsh = {
      enable = true;
      enableGlobalCompInit = false;
      promptInit = "";
    };

    # Rex server runs as polar (so sessions are polar's shells) and is reachable from
    # the iOS app at https://polarvortex.<tailnet>.ts.net:7297 via Tailscale Serve.
    # services.rex = {
    #   user = "polar";
    #   group = "users";
    #   tailscaleServe.enable = true;
    # };

    users.users.polar = {
      shell = pkgs.zsh;
      uid = 1000;
      isNormalUser = true;
      homeMode = "711";
      extraGroups = [
        "wheel"
        "networkmanager"
      ];
      initialHashedPassword = "$6$p/7P2dlx4xBEV72W$Ooep2JnmTJhTnexObNtAt3CNqRIhqgA2cD4bZtWMXOYAP.yBig8XToII0Fxy2Kc/Q12gep7Uqfsq6wIxRv7f21";
      maid = {
        imports = [
          # flakeCfg.flake.maidModules.ideaverse-sync
          # flakeCfg.flake.maidModules.claude-desktop-xvfb
          # flakeCfg.flake.maidModules.claude-dailylog
          # flakeCfg.flake.maidModules.health-import-listener
          # flakeCfg.flake.maidModules.pi
          flakeCfg.flake.maidModules.zsh
        ];

        # pi.settings.skills = ["/home/polar/repos/personal/ideaverse/aios/skills"];

        file.home = {
          # Keep syncthing out of the vault's .git directory so it doesn't
          # race with this host's git-based backup sync.
          # "repos/personal/ideaverse/.stignore".source = pkgs.writeText "ideaverse-stignore" "/.git\n/.obsidian/workspace*.json\n(?d).DS_Store\n";
          # "obsidian-headless".source = pkgs.writeShellScript "obsidian-headless" (builtins.readFile ../obsidian-headless.sh);
        };

        # claude-dailylog = {
        #   claudePackage = config.wrappers.claude-code-daily-log.wrapper;
        #   claudeBinName = "claude-daily-log";
        #   herdrPackage = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.herdr;
        #   # morgenApiTokenPath = config.sops.secrets.morgenApiToken.path;
        #   # claudeArgs = ["--dangerously-skip-permissions"];
        # };

        # claude-desktop-xvfb = {
        #   claudeDesktopPackage = inputs.claude-desktop.packages.${pkgs.stdenv.hostPlatform.system}.default;
        # };

        # health-import-listener = {
        #   importDir = "/home/polar/repos/personal/ideaverse/+/health auto export";
        #   tokenFile = config.sops.secrets.healthImportToken.path;
        # };

        # ideaverse-sync = {
        #   repoPath = "/home/polar/repos/personal/ideaverse";
        #   platform = "polarvortex";
        # };
      };
    };

    users.users.root = {
      initialHashedPassword = "$6$XvQOK8GW5DiRzqhR$g2LCu4rz2OfHRmYUbzaxTn/hz0h8IEHREG3/oW6U/8N3miFxUoYhIiLNjoS0cZXQHqgcaVAv5y1t4.eKxZi/..";
      shell = pkgs.bashInteractive;
    };
  };
}
