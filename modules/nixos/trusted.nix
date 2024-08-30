{
  config,
  lib,
  pkgs,
  ...
}: let
  one-password-gui-package = pkgs.unstable._1password-gui.override {
    polkitPolicyOwners = ["polar"];
  };
  one-password-package = pkgs.unstable._1password;
in {
  environment.systemPackages = [
    one-password-package
    one-password-gui-package
  ];

  # 1password copied from here
  # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/programs/_1password.nix

  users.groups.onepassword-cli.gid = config.ids.gids.onepassword-cli;
  users.groups.onepassword.gid = config.ids.gids.onepassword;

  security = {
    pam.services.login.enableGnomeKeyring = true;
    polkit.enable = true;
    wrappers = {
      "op" = {
        source = "${one-password-package}/bin/op";
        owner = "root";
        group = "onepassword-cli";
        setuid = false;
        setgid = true;
      };
      "1Password-BrowserSupport" = {
        source = "${one-password-gui-package}/share/1password/1Password-BrowserSupport";
        owner = "root";
        group = "onepassword";
        setuid = false;
        setgid = true;
      };
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
