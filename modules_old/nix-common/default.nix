{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.polar.defaults.nix;
in
{

  options.polar.defaults.nix = { enable = mkEnableOption "Nix defaults"; };

  config = mkIf cfg.enable {

    # Allow unfree licenced packages
    nixpkgs.config.allowUnfree = true;

    # Enable flakes
    nix = {

      # Save space by hardlinking store files
      autoOptimiseStore = true;

      # Enable flakes
      package = pkgs.nixFlakes;
      extraOptions = ''
        experimental-features = nix-command flakes ca-references
      '';

      # Clean up old generations after 30 days
      gc = {
        automatic = true;
        options = "--delete-older-than 8d";
      };

      # Users allowed to run nix
      allowedUsers = [ "@wheel" ];
    };
  };
}
