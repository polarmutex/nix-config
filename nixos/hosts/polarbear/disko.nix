_: {
  fileSystems = {
    "/" = {
      device = "rpool/nixos/root";
      fsType = "zfs";
      options = ["zfsutil" "X-mount.mkdir"];
    };

    "/home" = {
      device = "rpool/nixos/home";
      fsType = "zfs";
      options = ["zfsutil" "X-mount.mkdir"];
    };

    "/var/lib" = {
      device = "rpool/nixos/var/lib";
      fsType = "zfs";
      options = ["zfsutil" "X-mount.mkdir"];
    };

    "/var/log" = {
      device = "rpool/nixos/var/log";
      fsType = "zfs";
      options = ["zfsutil" "X-mount.mkdir"];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/04C5-27ED";
      fsType = "vfat";
    };
  };

  swapDevices = [
    {device = "/dev/disk/by-id/ata-Samsung_SSD_840_PRO_Series_S1AXNSAF912489P-part2";}
  ];
}
