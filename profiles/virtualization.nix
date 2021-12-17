{ pkgs, lib, ... }:
{
  virtualisation = {
    containers.enable = true;

    docker = {
      autoPrune.dates = mkDefault "weekly";
      autoPrune.enable = mkDefault true;
      enable = mkDefault true;
      enableOnBoot = mkDefault false;
      liveRestore = mkDefault true;
    };

    virtualbox = {
      host.enable = true;
      host.enableExtensionPack = true;
    };
    users.extraGroups.vboxusers.members = [ "polar" ];
  };
}
