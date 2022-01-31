{ pkgs, config, lib, ... }:
with lib;
let
  workInclude = {
    user = {
      name = "Brian Ryall";
      email = (builtins.fromJSON (builtins.readFile ../../.secrets/work/info.json)).work_email;
    };
  };
  cfg = config.polar.work;
in
{
  ###### interface
  options = {

    polar.work = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable work";
      };
    };
  };


  ###### implementation

  config = mkIf cfg.enable {
    home.sessionVariables = {
      GTK_IM_MODULE = "ibus";
      _JAVA_AWT_WM_NONREPARENTING = 1;
    };

    home.packages = with pkgs; [
      cmake
      brave
    ];

    programs.zsh.initExtra = ''
      export PATH=$HOME/netbeans-12.0/netbeans/bin:$HOME/.local/bin:$PATH
      export JDTLS_HOME=$HOME/jdtls
      xhost +local:docker
    '';

    xsession = {
      profileExtra = ''
        compton &
        xrandr --dpi 163
      '';
    };

    programs.git = {
      includes = [
        {
          condition = "gitdir:~/repos/work/";
          contents = workInclude;
        }
      ];
    };

    #systemd.user.services.work-vault-sync = {
    #  Unit = { Description = "work vault sync"; };
    #  Service = {
    #    CPUSchedulingPolicy = "idle";
    #    IOSchedulingClass = "idle";
    #    ExecStart = toString (
    #      pkgs.writeShellScript "work-vault-sync" ''
    #        #!/usr/bin/env sh
    #        WORK_VAULT_PATH="$HOME/repos/work/vaults"
    #        cd $WORK_VAULT_PATH
    #        CHANGES_EXIST="$(${pkgs.git}/bin/git status - porcelain | ${pkgs.coreutils}/bin/wc -l)"
    #        if [ "$CHANGES_EXIST" -eq 0 ]; then
    #          exit 0
    #        fi
    #        ${pkgs.git}/bin/git add .
    #        ${pkgs.git}/bin/git commit -q -m "Last Sync: $(${pkgs.coreutils}/bin/date +"%Y-%m-%d %H:%M:%S")"
    #      ''
    #    );
    #  };
    #};

    #systemd.user.timers.work-vault-sync = {
    #  Unit = { Description = "work vault periodic sync"; };
    #  Timer = {
    #    Unit = "work-vault-sync.service";
    #    OnCalendar = "*:0/30";
    #  };
    #  Install = { WantedBy = [ "timers.target" ]; };
    #};
  };
}
