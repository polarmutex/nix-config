{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.polar.server;
in
{

  imports = [ ../../users/polar.nix ];

  options.polar.server = {
    enable = mkEnableOption "Enable the default server configuration";

    hostname = mkOption {
      type = types.str;
      default = null;
      example = "deepblue";
      description = "hostname to identify the instance";
    };

    homeConfig = mkOption {
      type = types.attrs;
      default = null;
      example = "{}";
      description =
        "Main users account home-manager configuration for the host";
    };

  };

  config = mkIf cfg.enable {

    networking.hostName = cfg.hostname;

    home-manager.users.polar = cfg.homeConfig;

    environment.systemPackages = with pkgs; [
      git
      htop
      nix-index
      ripgrep
      wget
    ];

    polar.defaults = {
      environment.enable = true;
      locale.enable = true;
      nix.enable = true;
      zsh.enable = true;
      networking.enable = true;
    };
    polar.services = {
      openssh.enable = true;
    };
  };
}
