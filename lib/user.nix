{ pkgs, home-manager, lib, system, overlays, ...}:
{

  mkSystemUser = {name, groups, uid, shell, ...}:
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

}
