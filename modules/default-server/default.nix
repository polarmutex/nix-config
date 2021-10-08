{ lib, pkgs, config, inputs, self-overlay, ... }:
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

    home-manager.users.polar = {
      # Pass inputs to home-manager modules
      _module.args.flake-inputs = inputs;

      imports = [
        ../../home-manager/home-server.nix
        {
          nixpkgs.overlays =
            [ self-overlay inputs.nur.overlay inputs.neovim-nightly.overlay ];
        }
      ];
    };

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
