{ lib, pkgs, ... }:
let inherit (lib) mkDefault genAttrs; in
{
  boot = {
    kernelParams = [ ];
    #tmpOnTmpfs = mkDefault true;
    #supportedFilesystems = [ "ntfs" ];
  };

  environment.systemPackages = with pkgs; [
    asciinema
    firefox
    gnupg
    hdparm
    lm_sensors
    nmap-graphical
    pciutils
    unrar
    unzip
    usbutils
    xclip
    xdg_utils
  ];

  hardware = {
    pulseaudio.enable = mkDefault true;
    sane = {
      enable = mkDefault true;
      extraBackends = [ ];
    };
  };

  security.protectKernelImage = false;

  services = {
    xserver = {
      enable = true;
      libinput.enable = true;
    };
  };
}
