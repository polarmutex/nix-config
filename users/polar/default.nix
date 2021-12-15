{ ... }:
{
  #home-manager.users.polar = { suites, ... }: {
  #  imports = suites.base;
  #};

  users.users.polar = {
    uid = 1000;
    password = "nixos";
    description = "default";
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };
}
