{ config, pkgs, lib, ... }:
with lib;
{

  systemd.user.services.dendron-workspace-sync = {
    Unit = { Description = "dendron workspace sync"; };
    Service = {
      CPUSchedulingPolicy = "idle";
      IOSchedulingClass = "idle";
      ExecStart = toString (
        pkgs.writeShellScript "dendron-workspace-sync" ''
          #!/usr/bin/env sh
          DENDRON_PATH="$HOME/repos/personal/dendron-workspace"
          cd $DENDRON_PATH
          CHANGES_EXIST="$(${pkgs.git}/bin/git status - porcelain | ${pkgs.coreutils}/bin/wc -l)"
          if [ "$CHANGES_EXIST" -eq 0 ]; then
            exit 0
          fi
          ${pkgs.git}/bin/git add .
          ${pkgs.git}/bin/git commit -q -m "Last Sync: $(${pkgs.coreutils}/bin/date +"%Y-%m-%d %H:%M:%S")"
          ${pkgs.git}/bin/git pull --rebase
          ${pkgs.git}/bin/git push -q
        ''
      );
    };
  };

  systemd.user.timers.dendron-workspace-sync = {
    Unit = { Description = "dendron workspace periodic sync"; };
    Timer = {
      Unit = "dendron-workspace-sync.service";
      OnCalendar = "*:0/30";
    };
    Install = { WantedBy = [ "timers.target" ]; };
  };

  systemd.user.services.dendron-devlog-sync = {
    Unit = { Description = "dendron devlog sync"; };
    Service = {
      CPUSchedulingPolicy = "idle";
      IOSchedulingClass = "idle";
      ExecStart = toString (
        pkgs.writeShellScript "dendron-devlog-sync" ''
          #!/usr/bin/env sh
          DENDRON_PATH="$HOME/repos/personal/dendron-devlog"
          cd $DENDRON_PATH
          CHANGES_EXIST="$(${pkgs.git}/bin/git status - porcelain | ${pkgs.coreutils}/bin/wc -l)"
          if [ "$CHANGES_EXIST" -eq 0 ]; then
            exit 0
          fi
          ${pkgs.git}/bin/git add .
          ${pkgs.git}/bin/git commit -q -m "Last Sync: $(${pkgs.coreutils}/bin/date +"%Y-%m-%d %H:%M:%S")"
          ${pkgs.git}/bin/git pull --rebase
          ${pkgs.git}/bin/git push -q
        ''
      );
    };
  };

  systemd.user.timers.dendron-devlog-sync = {
    Unit = { Description = "dendron devlog periodic sync"; };
    Timer = {
      Unit = "dendron-devlog-sync.service";
      OnCalendar = "*:0/30";
    };
    Install = { WantedBy = [ "timers.target" ]; };
  };
}
