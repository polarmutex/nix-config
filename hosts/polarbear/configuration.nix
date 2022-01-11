{ pkgs, ... }: {

  imports = [ ./hardware-configuration.nix ];

  polar = {

    base.general.hostname = "blackbear";

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

  #services.xserver.videoDrivers = [ "nvidia" ];
  #services.printing.enable = true;
  #services.tailscale.enable = true;
  #hardware.sane.enable = true;

  #virtualisation.docker.enable = true;
  #programs.dconf.enable = true;
  #environment.systemPackages = with pkgs; [ tailscale ];
  #virtualisation.virtualbox.host.enable = true;
  #virtualisation.virtualbox.host.enableExtensionPack = true;
  #users.extraGroups.vboxusers.members = [ "polar" ];

}
