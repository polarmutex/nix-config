{ pkgs, ... }: {
  imports = [
    ./fonts.nix
  ];
  environment.systemPackages = with pkgs; [
    exfat
    ntfs3g
    st
    arandr
  ];
  networking.networkmanager.enable = true;
}
