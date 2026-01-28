{
  flake.nixosModules.virt-manager = {pkgs, ...}: {
    virtualisation.libvirtd.enable = true;
    programs.dconf.enable = true;
    environment.systemPackages = with pkgs; [
      virt-manager
      vagrant
    ];
  };
}
