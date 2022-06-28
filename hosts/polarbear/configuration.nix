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
  services.upower.enable = true;

  virtualisation.docker.enable = true;
  #programs.dconf.enable = true;
  environment.systemPackages = with pkgs; [
    tailscale
    ventoy-bin
    unzip
  ];
  #virtualisation.virtualbox.host.enable = true;
  #virtualisation.virtualbox.host.enableExtensionPack = true;
  #users.extraGroups.vboxusers.members = [ "polar" ];
  hardware.opengl.driSupport32Bit = true;

  # udiskctl service to manipulate storage devices. Mount and unmount without the need for sudo
  services.udisks2.enable = true;

  # Userspace virtual file system
  services.gvfs.enable = true;

  # Enable thumbnail service
  services.tumbler.enable = true;

  networking.networkmanager.enable = true;

}
