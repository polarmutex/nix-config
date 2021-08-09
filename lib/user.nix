{ pkgs, home-manager, lib, system, overlays, ... }:
{

  mkSystemUser = { name, groups, uid, shell, ... }:
    {

      users.users."${name}" = {
        name = name;
        isNormalUser = true;
        extraGroups = groups;
        uid = uid;
        initialPassword = "P@ssword01";
        shell = shell;
      };

    };

  mkHomeManagerUser = { roles, username }:
    home-manager.lib.homeManagerConfiguration {
      inherit system username pkgs;
      configuration = let
        mkRole = name: import (../roles/users + "/${name}");
        mod_roles = map (r: mkRole r) roles;

      in
        {
          nixpkgs.overlays = overlays;
          nixpkgs.config.allowUnfree = true;

          systemd.user.startServices = true;
          home.stateVersion = "20.09";
          home.username = username;
          home.homeDirectory = "/home/${username}";

          imports = mod_roles;
        };

      homeDirectory = "/home/${username}";
    };

}
