{
  flake.nixosModules.graphical = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      exfat
      ntfs3g
      st
      arandr
    ];
  };
}
