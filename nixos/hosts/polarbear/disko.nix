_: {
  fileSystems."/" = {
    device = "rpool/nixos/root";
    fsType = "zfs";
    options = ["zfsutil" "X-mount.mkdir"];
  };

  fileSystems."/home" = {
    device = "rpool/nixos/home";
    fsType = "zfs";
    options = ["zfsutil" "X-mount.mkdir"];
  };

  fileSystems."/var/lib" = {
    device = "rpool/nixos/var/lib";
    fsType = "zfs";
    options = ["zfsutil" "X-mount.mkdir"];
  };

  fileSystems."/var/log" = {
    device = "rpool/nixos/var/log";
    fsType = "zfs";
    options = ["zfsutil" "X-mount.mkdir"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/04C5-27ED";
    fsType = "vfat";
  };

  swapDevices = [
    {device = "/dev/disk/by-id/ata-Samsung_SSD_840_PRO_Series_S1AXNSAF912489P-part2";}
  ];
}
