_: {
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  swapDevices = [
    {
      device = "/dev/disk/by-label/swap";
    }
  ];
}
