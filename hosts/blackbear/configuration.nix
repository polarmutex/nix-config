{ config, lib, pkgs, ... }:
{

  custom = {
    #base.desktop = {
    #  enable = false;
    #  laptop = false;
    #};

    base.server = {
      enable = false;
    };

    system = {
      boot.mode = "efi";
    };
  };

  time.hardwareClockInLocalTime = true;

}
