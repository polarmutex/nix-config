{ pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];


  polar = {

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
