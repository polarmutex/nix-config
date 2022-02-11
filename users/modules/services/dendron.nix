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
      work = mkOption {
        type = types.bool;
        default = false;
        description = "work mode";
      };
    };
  };

  ###### implementation

  config = mkIf cfg.enable
    (mkMerge [
      {

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
      }
      (mkIf (cfg.work == false) {
        systemd.user.services.workspace-sync = {
          Unit = {
            Description = "personal workspace sync";
          };
          Service = {
            CPUSchedulingPolicy = "idle";
            IOSchedulingClass = "idle";
            ExecStart = toString (
              pkgs.writeShellScript "workspace-sync" ''
                #!/usr/bin/env sh
                WORKSPACE_PATH="$HOME/repos/personal/workspace"
                cd $WORKSPACE_PATH
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

        systemd.user.timers.workspace-sync = {
          Unit = { Description = "personal workspace periodic sync"; };
          Timer = {
            Unit = "workspace-sync.service";
            OnCalendar = "*:0/30";
          };
          Install = { WantedBy = [ "timers.target" ]; };
        };

        systemd.user.services.biblelog-sync = {
          Unit = {
            Description = "biblelog sync";
          };
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
      })
      (mkIf (cfg.work == true) {
        systemd.user.services.workspace-sync = {
          Unit = {
            Description = "work workspace sync";
          };
          Service = {
            CPUSchedulingPolicy = "idle";
            IOSchedulingClass = "idle";
            ExecStart = toString (
              pkgs.writeShellScript "workspace-sync" ''
                #!/usr/bin/env sh
                WORKSPACE_PATH="$HOME/repos/work/workspace"
                cd $WORKSPACE_PATH
                CHANGES_EXIST="$(${pkgs.git}/bin/git status - porcelain | ${pkgs.coreutils}/bin/wc -l)"
                if [ "$CHANGES_EXIST" -eq 0 ]; then
                  exit 0
                fi
                ${pkgs.git}/bin/git add .
                ${pkgs.git}/bin/git commit -q -m "Last Sync: $(${pkgs.coreutils}/bin/date +"%Y-%m-%d %H:%M:%S")"
              ''
            );
          };
        };

        systemd.user.timers.workspace-sync = {
          Unit = { Description = "work workspace periodic sync"; };
          Timer = {
            Unit = "workspace-sync.service";
            OnCalendar = "*:0/30";
          };
          Install = { WantedBy = [ "timers.target" ]; };
        };
      })
    ]);
}
