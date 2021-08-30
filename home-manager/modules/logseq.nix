{ pkgs, ... }:
{
  home.packages = with pkgs; [
    logseq
  ];

  systemd.user.services.logseq-sync = {
    Unit = { Description = "logseq sync"; };
    Service = {
      CPUSchedulingPolicy = "idle";
      IOSchedulingClass = "idle";
      ExecStart = toString (
        pkgs.writeShellScript "logseq-sync" ''
          #!/usr/bin/env sh
          LOGSEQ_PATH="$HOME/repos/devlog"
          cd $LOGSEQ_PATH
          CHANGES_EXIST="$(${pkgs.git}/bin/git status - porcelain | ${pkgs.coreutils}/bin/wc -l)"
          if [ "$CHANGES_EXIST" -eq 0 ]; then
            exit 0
          fi
          ${pkgs.git}/bin/git pull
          ${pkgs.git}/bin/git add .
          ${pkgs.git}/bin/git commit -q -m "Last Sync: $(${pkgs.coreutils}/bin/date +"%Y-%m-%d %H:%M:%S")"
          ${pkgs.git}/bin/git push -q
        ''
      );
    };
  };

  systemd.user.timers.logseq-sync = {
    Unit = { Description = "logseq periodic sync"; };
    Timer = {
      Unit = "logseq-sync.service";
      OnCalendar = "*:0/30";
    };
    Install = { WantedBy = [ "timers.target" ]; };
  };
}
