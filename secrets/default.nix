{ pkgs, lib, inputs, ... }:
let
  secrets = import ./secretdata.nix { inherit lib; };
in
{
  config = {
    sops = {
      inherit secrets;
    };
  };
}
