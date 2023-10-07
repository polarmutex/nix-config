{
  lib,
  pkgs,
  ...
}: {
  programs = {
    _1password = {
      enable = true;
      package = pkgs.unstable._1password;
    };
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = ["polar"];
      package = pkgs.unstable._1password-gui;
    };
  };

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = ["graphical-session.target"];
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
    user.services._1password-agent-1 = {
      description = "1password-agent-1";
      wantedBy = ["graphical-session.target"];
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${lib.getExe pkgs._1password-gui} --silent";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  security.polkit.enable = true;

  security.pam.services.login.enableGnomeKeyring = true;

  environment.systemPackages = [
    #pkgs.gnome.seahorse
  ];

  services.gnome.gnome-keyring.enable = true;
  services.dbus.packages = with pkgs; [gcr];
}
