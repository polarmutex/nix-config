{
  imports = [
    ./configuration.nix
  ];

  profiles = {
    caches.enable = true;
    core.enable = true;
    display-manager.enable = true;
    doas.enable = true;
    fonts.enable = true;
    nix.enable = true;
    wm-helper.enable = true;
  };

  users = {
    blackbear.enable = true;
  };
}
