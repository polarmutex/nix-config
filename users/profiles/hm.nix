{ config, nixosConfig, lib, ... }:
let
  inherit (lib) mkDefault;
in
{
  home = {
    # by default, state version is machine's state version
    stateVersion = mkDefault "21.11";
  };
}
