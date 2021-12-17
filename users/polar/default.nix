{ hmUsers, ... }:
{
  home-manager.users = { inherit (hmUsers) polar; };

  users.users.polar = {
    uid = 1000;
    password = "nixos";
    description = "polar";
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };
}
