{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.polar.virtualisation;
in
{

  options.polar.virtualisation.docker = {
    enable = mkEnableOption "Docker virtualisation";
  };

  options.polar.virtualisation.virtualbox = {
    enable = mkEnableOption "Virt-Manager virtualisation";
  };

  # TODO separate virtualbox and docker into separate enable options. For now
  # the virtualbox.enable option enables both while the docker.enable does
  # nothhing

  config = mkIf cfg.virtualbox.enable {

    virtualisation.docker.enable = true;
    users.users.polar.extraGroups = [ "libvirt docker" ];

    virtualisation.libvirtd.enable = true;

  };
}
