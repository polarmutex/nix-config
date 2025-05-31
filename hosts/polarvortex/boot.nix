_: {
  # configure boot
  boot = {
    loader.grub = {
      enable = true;
      forceInstall = true;
      device = "/dev/sda";
    };
    loader.timeout = 10;
  };
}
