{
  flake.nixosModules.host-polarbear = {
    config,
    inputs,
    lib,
    modulesPath,
    pkgs,
    # self',
    ...
  }: {
    imports = [
      "${modulesPath}/installer/scan/not-detected.nix"
    ];

    # Disable documentation to avoid build failures with missing modules
    documentation.nixos.enable = false;

    boot = {
      initrd.kernelModules = ["nvidia"];
      initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod"];
      loader.systemd-boot.enable = true;
      loader.efi.canTouchEfiVariables = true;
      kernelModules = [
        "kvm-amd"
      ];
      kernelPatches = with inputs.nixpkgs.lib; [
        # {
        #   name = "disable-amdgpu";
        #   patch = null;
        #   extraStructuredConfig = {
        #     DRM_AMDGPU = kernel.no;
        #     DRM_AMDGPU_CIK = mkForce (kernel.option kernel.no);
        #     DRM_AMDGPU_SI = mkForce (kernel.option kernel.no);
        #     DRM_AMDGPU_USERPTR = mkForce (kernel.option kernel.no);
        #     DRM_AMD_DC_FP = mkForce (kernel.option kernel.no);
        #     DRM_AMD_DC_SI = mkForce (kernel.option kernel.no);
        #     HSA_AMD = mkForce (kernel.option kernel.no);
        #   };
        # }
      ];
      extraModulePackages = [
        config.boot.kernelPackages.nvidia_x11
      ];
    };

    environment.systemPackages = with pkgs; [
      nixpkgs-review
      nix-update
      qmk
      lshw
      yt-dlp
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

    # The open source driver does not support Maxwell GPUs.

    services.xserver.videoDrivers = ["nvidia"];
    hardware = {
      # graphics = {
      #   enable = true;
      #   enable32Bit = true;
      # };
      nvidia = {
        modesetting.enable = true;
        powerManagement = {
          enable = false;
          finegrained = false;
        };
        open = true;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.latest;
        # prime = {
        #   # Bus ID of the Intel GPU.
        #   intelBusId = lib.mkDefault "PCI:0:2:0";
        #
        #   # Bus ID of the NVIDIA GPU.
        #   nvidiaBusId = lib.mkDefault "PCI:1:0:0";
        # };
      };
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
      initialHashedPassword = "$6$p/7P2dlx4xBEV72W$Ooep2JnmTJhTnexObNtAt3CNqRIhqgA2cD4bZtWMXOYAP.yBig8XToII0Fxy2Kc/Q12gep7Uqfsq6wIxRv7f21";
    };

    services.udev.packages = [
      pkgs.qmk-udev-rules
    ];
  };
}
