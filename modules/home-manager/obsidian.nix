{
  pkgs,
  lib,
  ...
}:
with lib; {
  home.packages = with pkgs; let
    obsidian-updated =
      obsidian.overrideAttrs
      (_: rec {
        version = "1.8.4";
        filename =
          if stdenv.hostPlatform.isDarwin
          then "Obsidian-${version}.dmg"
          else "obsidian-${version}.tar.gz";
        src = fetchurl {
          url = "https://github.com/obsidianmd/obsidian-releases/releases/download/v${version}/${filename}";
          hash =
            if stdenv.hostPlatform.isDarwin
            then "sha256-kg0gH4LW78uKUxnvE1CG8B1BvJzyO8vlP6taLvmGw/s="
            else "sha256-bvmvzVyHrjh1Yj3JxEfry521CMX3E2GENmXddEeLwiE=";
        };
      });
  in [
    obsidian-updated
  ];

  systemd.user.services.obsidian-second-brain-sync = {
    Unit = {Description = "Obsidian Second Brain Sync";};
    Service = {
      CPUSchedulingPolicy = "idle";
      IOSchedulingClass = "idle";
      ExecStart = toString (
        pkgs.writeShellScript "obsidian-second-brain-sync" ''
          #!/usr/bin/env sh
          OBSIDIAN_PATH="$HOME/repos/personal/obsidian-second-brain/main"
          cd $OBSIDIAN_PATH
          CHANGES_EXIST="$(${pkgs.git}/bin/git status - porcelain | ${pkgs.coreutils}/bin/wc -l)"
          if [ "$CHANGES_EXIST" -eq 0 ]; then
            exit 0
          fi
          ${pkgs.git}/bin/git add .
          ${pkgs.git}/bin/git commit -q -m "Last Sync: $(${pkgs.coreutils}/bin/date +"%Y-%m-%d %H:%M:%S") on nixos"
          ${pkgs.git}/bin/git pull --rebase
          ${pkgs.git}/bin/git push -q
        ''
      );
    };
  };

  systemd.user.timers.obsidian-second-brain-sync = {
    Unit = {Description = "Obsidian Second Brain Periodic Sync";};
    Timer = {
      Unit = "obsidian-second-brain-sync.service";
      OnCalendar = "*:0/30";
    };
    Install = {WantedBy = ["timers.target"];};
  };
}
