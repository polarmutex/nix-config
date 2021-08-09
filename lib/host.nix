{ system, pkgs, home-manager, lib, user, ... }:
with builtins;
{

  mkHost = { name, NICs, initrdMods, kernelMods, kernelParams, kernelPackage, extraModulePackages, roles, cpuCores, users }:
    let

      networkCfg = listToAttrs (
        map (
          n: {
            name = "${n}";
            value = { useDHCP = true; };
          }
        ) NICs
      );

      roles_mods = (map (r: mkRole r) roles);
      mkRole = name: import (../roles + "/${name}");

      sys_users = (map (u: user.mkSystemUser u) users);

    in
      lib.nixosSystem {

        inherit system;

        modules = [
          {
            imports = roles_mods ++ sys_users;

            networking.hostName = "${name}";
            networking.interfaces = networkCfg;

            networking.networkmanager.enable = true;
            networking.useDHCP = false; # Disable any new interfaces added that is not in the config.

            boot.initrd.availableKernelModules = initrdMods;
            boot.kernelModules = kernelMods;
            boot.kernelParams = kernelParams;
            boot.kernelPackages = kernelPackage;
            boot.extraModulePackages = extraModulePackages;

            nixpkgs.pkgs = pkgs;
            nix.maxJobs = lib.mkDefault cpuCores;

            system.stateVersion = "21.05";
          }
        ];
      };
}
