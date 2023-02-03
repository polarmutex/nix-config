{
  imports = [
    ./configuration.nix
  ];

  profiles = {
    bluetooth.enable = true;
    caches.enable = true;
    core.enable = true;
    display-manager.enable = true;
    doas.enable = true;
    fonts.enable = true;
    graphical.enable = true;
    nix.enable = true;
    openssh.enable = true;
    trusted.enable = true;
    wm-helper.enable = true;
    yubikey.enable = true;
  };

  users = {
    polarbear.enable = true;
  };
}
