{ lib, config, pkgs, ... }:
let
  inherit (lib) mkIf mkDefault;
in
{
  programs.firefox = {
    enable = mkDefault true;

    package = pkgs.firefox.override {
      cfg = { };
    };

    profiles = {
      default = {
        id = 0;
        name = "default";
        isDefault = mkDefault true;
        settings = { };
      };
    };
  };
}
