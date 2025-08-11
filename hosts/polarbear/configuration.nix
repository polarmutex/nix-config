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

  boot =
    #       let
    #   amdgpu-kernel-module = pkgs.callPackage ./packages/amdgpu-kernel-module.nix {
    #     # Make sure the module targets the same kernel as your system is using.
    #     kernel = config.boot.kernelPackages.kernel;
    #   };
    #   # linuxPackages_latest 6.13 (or linuxPackages_zen 6.13)
    #   # amdgpu-stability-patch = pkgs.fetchpatch {
    #   #   name = "amdgpu-stability-patch";
    #   #   url = "https://github.com/torvalds/linux/compare/ffd294d346d185b70e28b1a28abe367bbfe53c04...SeryogaBrigada:linux:4c55a12d64d769f925ef049dd6a92166f7841453.diff";
    #   #   hash = "sha256-q/gWUPmKHFBHp7V15BW4ixfUn1kaeJhgDs0okeOGG9c=";
    #   # };
    #   # linuxPackages_zen 6.12
    #   amdgpu-stability-patch = pkgs.fetchpatch {
    #     name = "amdgpu-stability-patch-zen";
    #     url = "https://github.com/zen-kernel/zen-kernel/compare/fd00d197bb0a82b25e28d26d4937f917969012aa...WhiteHusky:zen-kernel:f4c32ca166ad55d7e2bbf9adf121113500f3b42b.diff";
    #     hash = "sha256-bMT5OqBCyILwspWJyZk0j0c8gbxtcsEI53cQMbhbkL8=";
    #   };
    # in
    {
      initrd.kernelModules = ["nvidia"];
      initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod"];
      loader.systemd-boot.enable = true;
      loader.efi.canTouchEfiVariables = true;
      kernelModules = ["kvm-amd"];
      # amdgpu instability with context switching between compute and graphics
      # https://bbs.archlinux.org/viewtopic.php?id=301798
      # side-effects: plymouth fails to show at boot, but does not interfere with booting
      extraModulePackages = [
        config.boot.kernelPackages.broadcom_sta
        config.boot.kernelPackages.nvidia_x11
        # (amdgpu-kernel-module.overrideAttrs (_: {
        #   patches = [
        #     amdgpu-stability-patch
        #   ];
        # }))
      ];
    };

  environment.systemPackages = with pkgs; [
    nixpkgs-review
    nix-update
    qmk
    lshw
  ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/61cfccfe-4287-4f76-b146-d06c113313d4";
    fsType = "btrfs";
    options = ["subvol=root" "compress=zstd"];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/61cfccfe-4287-4f76-b146-d06c113313d4";
    fsType = "btrfs";
    options = ["subvol=home" "compress=zstd"];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/61cfccfe-4287-4f76-b146-d06c113313d4";
    fsType = "btrfs";
    options = ["subvol=nix" "compress=zstd" "noatime"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/12CE-A600";
    fsType = "vfat";
    options = ["fmask=0022" "dmask=0022"];
  };

  swapDevices = [];

  hardware = {
    # cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    # opengl.enable = true;
  };
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

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
    initialHashedPassword = "$6$p/7P2dlx4xBEV72W$Ooep2JnmTJhTnexObNtAt3CNqRIhqgA2cD4bZtWMXOYAP.yBig8XToII0Fxy2Kc/Q12gep7Uqfsq6wIxRv7f21";
  };
  programs.fish.enable = true;

  services.udev.packages = [
    pkgs.qmk-udev-rules
  ];
}
