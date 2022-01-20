{ pkgs, ... }: {

  imports = [ ./hardware-configuration.nix ];

  polar = {

    base.general.hostname = "polarbear";

    base.desktop = {
      enable = true;
      laptop = false;
    };

    system = {
      boot.mode = "efi";
      yubikey.enable = true;
    };
  };

  time.hardwareClockInLocalTime = true;

  services.xserver.videoDrivers = [ "nvidia" ];
  #services.printing.enable = true;
  services.tailscale.enable = true;
  #hardware.sane.enable = true;

  #virtualisation.docker.enable = true;
  #programs.dconf.enable = true;
  environment.systemPackages = with pkgs; [
    tailscale
    ventoy-bin
  ];
  #virtualisation.virtualbox.host.enable = true;
  #virtualisation.virtualbox.host.enableExtensionPack = true;
  #users.extraGroups.vboxusers.members = [ "polar" ];

}
