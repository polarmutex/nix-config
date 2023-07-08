_: {
  # configure boot
  boot = {
    loader.grub.extraConfig = ''
      serial --speed=19200 --unit=0 --word=8 --parity=no --stop=1;
      terminal_input serial;
      terminal_output serial;
    '';
    loader.grub.enable = true;
    loader.grub.forceInstall = true;
    loader.grub.device = "nodev";
    loader.timeout = 10;
  };
}
