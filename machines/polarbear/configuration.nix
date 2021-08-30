# Configuration for kartoffel
{ self, ... }: {

  imports = [ ./hardware-configuration.nix ];

  # environment.systemPackages = [self.wezterm];

  polar.desktop.homeConfig = {
    imports = [
      ../../home-manager/home.nix
      {
        nixpkgs.overlays = [
          self.overlay
          self.inputs.neovim-flake.overlay
        ];
      }
    ];
  };

  polar.desktop = {
    enable = true;
    hostname = "polarbear";
  };

  services.xserver.videoDrivers = [ "nvidia" ];
  #hardware.sane.enable = true;

  # To build raspi images
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
}
