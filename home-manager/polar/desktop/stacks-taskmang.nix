{ pkgs, ... }:
{
  home.packages = with pkgs; [
    stacks-task-manager
    #my.stacks-task-manager
  ];

  systemd.user.services.stacks-sync = {
    Unit = { Description = "Stacks Task Manager sync"; };
    Service = {
      CPUSchedulingPolicy = "idle";
      IOSchedulingClass = "idle";
      ExecStart = toString (
        pkgs.writeShellScript "stacks-sync" ''
          #!/usr/bin/env sh
          STACKS_PATH="$HOME/repos/personal/personal_kanban"
          cd $STACKS_PATH
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

  systemd.user.timers.stacks-sync = {
    Unit = { Description = "stacks periodic sync"; };
    Timer = {
      Unit = "stacks-sync.service";
      OnCalendar = "*:0/30";
    };
    Install = { WantedBy = [ "timers.target" ]; };
  };
}
