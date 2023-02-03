{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  home.packages = with pkgs; [
    obsidian
  ];

  systemd.user.services.obsidian-sync = {
    Unit = {Description = "Obsidian sync";};
    Service = {
      CPUSchedulingPolicy = "idle";
      IOSchedulingClass = "idle";
      #ExecStart = "${autoCommitVaults}/bin/obsidian-sync";
      ExecStart = toString (
        pkgs.writeShellScript "obsidian-sync" ''
          #!/usr/bin/env sh
          OBSIDIAN_PATH="$HOME/repos/personal/obsidian-vaults"
          cd $OBSIDIAN_PATH
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

  systemd.user.timers.obsidian-sync = {
    Unit = {Description = "Obsidian periodic sync";};
    Timer = {
      Unit = "obsidian-sync.service";
      OnCalendar = "*:0/30";
    };
    Install = {WantedBy = ["timers.target"];};
  };
}
