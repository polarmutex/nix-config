_: {
  # configure boot
  boot = {
    loader.grub = {
      extraConfig = ''
        serial --speed=19200 --unit=0 --word=8 --parity=no --stop=1;
        terminal_input serial;
        terminal_output serial;
      '';
      enable = true;
      forceInstall = true;
      device = "nodev";
    };
    loader.timeout = 10;
  };
}
