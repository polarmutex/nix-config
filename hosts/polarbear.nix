{ config, suites, pkgs, lib, ... }:
{
  #imports = suites.base ++ [ ../users/nixos ];
  imports = [ ../users/nixos ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.package = pkgs.nixFlakes;
  nix.extraOptions = "experimental-features = nix-command flakes";

  networking.networkmanager.enable = true;
  networking.useDHCP = false;
  networking.interfaces.enp0s3.useDHCP = true;

  services.openssh.enable = true;
  services.openssh.passwordAuthentication = true;
  services.openssh.permitRootLogin = "yes";

  environment.systemPackages = with pkgs; [
    git
    neovim
  ];

  boot.initrd.availableKernelModules = [ "ata_piix" "ohci_pci" "ehci_pci" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };
  fileSystems."/boot" =
    {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };

  swapDevices = [
    { device = "/dev/disk/by-label/swap"; }
  ];

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  virtualisation.virtualbox.guest.enable = true;

  users.users.root.initialPassword = "root";

  system.stateVersion = " 21.05 ";
}



