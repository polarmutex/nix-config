{
  config,
  lib,
  modulesPath,
  pkgs,
  self',
  ...
}: {
  imports = [
    "${modulesPath}/installer/scan/not-detected.nix"
  ];

  boot = {
    initrd.kernelModules = [];
    initrd.availableKernelModules = ["xhci_pci" "ehci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" "sr_mod"];
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelModules = ["kvm-intel" "wl" "nvidia"];
    extraModulePackages = [config.boot.kernelPackages.broadcom_sta];
  };

  environment.systemPackages = with pkgs; [
    nixpkgs-review
    nix-update
    qmk
    lshw
  ];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/75bfaf03-6d13-4728-ac38-4474988e89b3";
      fsType = "btrfs";
      options = ["subvol=root" "compress=zstd"];
    };

    "/home" = {
      device = "/dev/disk/by-uuid/75bfaf03-6d13-4728-ac38-4474988e89b3";
      fsType = "btrfs";
      options = ["subvol=home" "compress=zstd"];
    };

    "/nix" = {
      device = "/dev/disk/by-uuid/75bfaf03-6d13-4728-ac38-4474988e89b3";
      fsType = "btrfs";
      options = ["subvol=nix" "compress=zstd" "noatime"];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/EEFA-2B56";
      fsType = "vfat";
    };

    "/swap" = {
      device = "/dev/disk/by-uuid/75bfaf03-6d13-4728-ac38-4474988e89b3";
      fsType = "btrfs";
      options = ["subvol=swap"];
    };
  };
  swapDevices = [{device = "/swap/swapfile";}];

  hardware = {
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    opengl.enable = true;
  };

  networking.useDHCP = lib.mkDefault true;
  networking.hostId = "f98b90a0";
  networking.hostName = "polarbear";

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = ["/"];
  };

  users.users.polar = {
    uid = 1000;
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "video"
      "audio"
      "disk"
      "networkmanager"
      "libvirtd"
      "polkituser"
      "qemu-libvirtd"
      "libvirtd"
    ];
    initialHashedPassword = "$6$p/7P2dlx4xBEV72W$Ooep2JnmTJhTnexObNtAt3CNqRIhqgA2cD4bZtWMXOYAP.yBig8XToII0Fxy2Kc/Q12gep7Uqfsq6wIxRv7f21";
  };
  programs.fish.enable = true;

  services.udev.packages = [
    pkgs.qmk-udev-rules
  ];
}
