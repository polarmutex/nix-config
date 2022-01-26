{ config, pkgs, lib, inputs, ... }:
let
  #secret_files = import ./secretdata.nix { inherit lib; };
  secrets = [
    "work_username"
  ];
  genDefaultPerms = secret: {
    ${secret} = {
      mode = "0440";
      owner = config.users.users.polar.name;
      group = config.users.users.polar.group;
    };
  };
in
{
  # TODO: have separate lists for desktop and server
  config = {
    sops = {
      #inherit secrets;
      defaultSopsFile = ./secrets.yaml;
      secrets = (((lib.foldl' lib.mergeAttrs) { }) (builtins.map genDefaultPerms secrets));
    };
  };
}
