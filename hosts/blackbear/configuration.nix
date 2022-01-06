{ pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];


  custom = {

    base.general.hostname = "blackbear";

    base.desktop = {
      enable = true;
      laptop = false;
    };

    system = {
      boot.mode = "efi";
    };
  };

  time.hardwareClockInLocalTime = true;

}
