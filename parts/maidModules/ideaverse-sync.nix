{
  flake.maidModules.ideaverse-sync = {
    pkgs,
    config,
    lib,
    ...
  }: {
    options.ideaverse-sync = {
      repoPath = lib.mkOption {
        type = lib.types.str;
        default = "/home/polar/repos/personal/ideaverse/main";
      };
      timerMinutes = lib.mkOption {
        type = lib.types.int;
        default = 30;
      };
      platform = lib.mkOption {
        type = lib.types.str;
        default = "nixos";
      };
    };

    config = let
      cfg = config.ideaverse-sync;
      syncScript = ''
        export GIT_SSH_COMMAND='ssh -i /home/polar/.ssh/id_ed25519 -o IdentitiesOnly=yes'
        cd ${cfg.repoPath}
        git add .
        git diff --cached --quiet && exit 0
        git commit -q -m "Last Sync: $(${pkgs.coreutils}/bin/date +"%Y-%m-%d %H:%M:%S") on ${cfg.platform}"
        if ! git pull --rebase -q; then
          git rebase --abort
          git pull --no-rebase -X ours -q
        fi
        git push -q
      '';
      commonPath = [
        pkgs.git-polar
        pkgs.coreutils
        pkgs.openssh
      ];
    in {
      systemd.services.obsidian-ideaverse-sync = {
        path = commonPath;
        script = syncScript;
      };

      systemd.services.obsidian-ideaverse-sync-shutdown = {
        wantedBy = ["multi-user.target"];
        after = ["network-online.target"];
        path = commonPath;
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = "${pkgs.coreutils}/bin/true";
        };
        preStop = syncScript;
      };

      systemd.timers.obsidian-ideaverse-sync = {
        unitConfig = {Description = "Obsidian Ideaverse Periodic Sync";};
        timerConfig = {
          Unit = "obsidian-ideaverse-sync.service";
          OnCalendar = "*:0/${toString cfg.timerMinutes}";
        };
        wantedBy = ["timers.target"];
      };
    };
  };
}
