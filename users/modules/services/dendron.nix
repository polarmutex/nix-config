{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.polar.services.dendron;
in
{
  ###### interface

  options = {
    polar.services.dendron = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable dendron";
      };
    };
  };

  ###### implementation

  config = mkIf cfg.enable {

    home.packages = with pkgs; [
    ];

    systemd.user.services.devlog-sync = {
      Unit = { Description = "devlog sync"; };
      Service = {
        CPUSchedulingPolicy = "idle";
        IOSchedulingClass = "idle";
        ExecStart = toString (
          pkgs.writeShellScript "devlog-sync" ''
            #!/usr/bin/env sh
            DEVLOG_PATH="$HOME/repos/personal/devlog"
            cd $DEVLOG_PATH
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

    systemd.user.timers.devlog-sync = {
      Unit = { Description = "devlog periodic sync"; };
      Timer = {
        Unit = "devlog-sync.service";
        OnCalendar = "*:0/30";
      };
      Install = { WantedBy = [ "timers.target" ]; };
    };

    systemd.user.services.biblelog-sync = {
      Unit = { Description = "biblelog sync"; };
      Service = {
        CPUSchedulingPolicy = "idle";
        IOSchedulingClass = "idle";
        ExecStart = toString (
          pkgs.writeShellScript "biblelog-sync" ''
            #!/usr/bin/env sh
            DEVLOG_PATH="$HOME/repos/personal/biblelog"
            cd $DEVLOG_PATH
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

    systemd.user.timers.biblelog-sync = {
      Unit = { Description = "biblelog periodic sync"; };
      Timer = {
        Unit = "biblelog-sync.service";
        OnCalendar = "*:0/30";
      };
      Install = { WantedBy = [ "timers.target" ]; };
    };
  };
}
