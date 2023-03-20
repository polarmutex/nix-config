{self, ...} @ inputs: {...}: {
  imports = [
    ./configuration.nix
  ];

  nix.allowedUnfree = [
    "broadcom-sta"
    "corefonts"
    "nvidia-settings"
    "nvidia-x11"
    "1password"
    "1password-cli"
  ];

  profiles = {
    bluetooth.enable = true;
    core.enable = true;
    display-manager.enable = true;
    doas.enable = true;
    fonts.enable = true;
    graphical.enable = true;
    openssh.enable = true;
    trusted.enable = true;
    wm-helper.enable = true;
    virt-manager.enable = true;
    yubikey.enable = true;
  };

  #users = {
  #  polarbear.enable = true;
  #};
}
