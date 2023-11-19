_: {
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
}
