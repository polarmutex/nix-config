{ pkgs, ... }: {
  programs = {
    _1password = {
      enable = true;
      package = pkgs.unstable._1password;
      gid = 5001;
    };
    _1password-gui = {
      enable = true;
      package = pkgs.unstable._1password-gui;
      polkitPolicyOwners = ["polar"];
      gid = 5000;
    };
  };

  security.pam.services.login.enableGnomeKeyring = true;

  #services = {
  #  dbus.packages = with pkgs; [ gcr ];
  #  gnome.gnome-keyring.enable = true;
  #};
}
