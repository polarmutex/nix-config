# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot.initrd.availableKernelModules = [
    "ahci"
    "xhci_pci"
    "virtio_pci"
    "sr_mod"
    "virtio_blk"
  ];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    #device = "/dev/disk/by-uuid/cf9e2ae4-757f-4e1e-b305-8597785cacd3";
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  swapDevices = [];

  #nixpkgs.hostPlatform.system = lib.mkDefault "x86_64-linux";
  nixpkgs.hostPlatform.system = "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  #virtualisation.virtualbox.guest.enable = true;
  #virtualisation.virtualbox.guest.x11 = true;
}