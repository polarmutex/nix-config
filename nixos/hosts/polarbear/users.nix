{pkgs, ...}: {
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
    shell = pkgs.fish;
  };
  programs.fish.enable = true;
}
