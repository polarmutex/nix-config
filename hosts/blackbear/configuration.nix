{ self, ... }:
{ pkgs, ... }: {

  imports = [ ./hardware-configuration.nix ];

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
