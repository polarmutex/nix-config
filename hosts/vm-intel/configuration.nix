{
  config,
  lib,
  modulesPath,
  pkgs,
  self',
  ...
}: {
  imports = [];

  boot = {
    initrd = {
      availableKernelModules = [
        "ata_piix"
        "mptspi"
        "uhci_hcd"
        "ehci_pci"
        "sd_mod"
        "sr_mod"
      ];
      kernelModules = [];
    };
    kernelModules = [];
    extraModulePackages = [];
    loader.grub = {
      enable = true;
      device = "/dev/sda";
    };
  };

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  swapDevices = [];

  networking.useDHCP = lib.mkDefault true;
}
