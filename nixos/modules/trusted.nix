_: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.profiles.trusted;
in {
  options.profiles.trusted = {
    enable = lib.mkEnableOption "enable trusted";
  };
  config = lib.mkIf cfg.enable {
    programs = {
      _1password = {
        enable = true;
      };
      _1password-gui = {
        enable = true;
        polkitPolicyOwners = ["polar"];
      };
    };

    security.pam.services.login.enableGnomeKeyring = true;

    environment.systemPackages = [
      #pkgs.gnome.seahorse
    ];

    services.gnome.gnome-keyring.enable = true;
    services.dbus.packages = with pkgs; [gcr];
  };
}
