_: {
  fileSystems."/" = {
    device = "/dev/sda";
    fsType = "ext4";
  };

  swapDevices = [
    {device = "/dev/sdb";}
  ];
}
