_: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.profiles.virt-manager;
in {
  options.profiles.virt-manager = {
    enable = lib.mkEnableOption "enable virt-manager";
  };
  config = lib.mkIf cfg.enable {
    virtualisation.libvirtd.enable = true;
    programs.dconf.enable = true;
    environment.systemPackages = with pkgs; [virt-manager];
  };
}
