{
  pkgs,
  lib,
  ...
}: {
  security = {
    pam.services.login.enableGnomeKeyring = true;
    polkit.enable = true;
  };

  systemd = {
    user.services._1password-agent-1 = {
      description = "1password-agent-1";
      wantedBy = ["graphical-session.target"];
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${lib.getExe pkgs.unstable._1password-gui} --silent";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  services.gnome.gnome-keyring.enable = true;
  services.dbus.packages = with pkgs; [gcr];
}
