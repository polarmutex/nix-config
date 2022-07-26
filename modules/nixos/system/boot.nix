{ config, lib, ... }:

with lib;

let
  cfg = config.polar.system.boot;
in

{

  ###### interface

  options = {

    polar.system.boot = {
      mode = mkOption {
        type = types.enum [ "efi" "grub" "raspberry" "linode" ];
        description = ''
          Sets mode for boot options.
        '';
      };

      device = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Device for GRUB boot loader.
        '';
      };
    };

  };


  ###### implementation

  config = mkMerge [
    {
      assertions = [
        {
          assertion = cfg.mode == "grub" -> cfg.device != null;
          message = "custom.system.boot.device needs to be set for grub mode.";
        }
      ];
    }

    (mkIf (cfg.mode == "efi")
      {
        boot.loader = {
          efi.canTouchEfiVariables = true;

          systemd-boot = {
            enable = true;
            editor = false;
          };
        };
      }
    )

    (mkIf (cfg.mode == "grub")
      {
        boot.loader.grub = {
          inherit (cfg) device;

          enable = true;
          version = 2;
        };
      }
    )

    (mkIf (cfg.mode == "raspberry")
      {
        boot = {
          loader = {
            generic-extlinux-compatible.enable = true;

            grub.enable = false;
          };

          kernel.sysctl = {
            "vm.dirty_background_ratio" = 5;
            "vm.dirty_ratio" = 80;
          };

          kernelParams = [ "cma=32M" ];
        };
      }
    )

    (mkIf (cfg.mode == "linode")
      {
        boot.loader.grub.extraConfig = ''
          serial --speed=19200 --unit=0 --word=8 --parity=no --stop=1;
          terminal_input serial;
          terminal_output serial;
        '';
        boot.loader.grub.enable = true;
        boot.loader.grub.version = 2;
        boot.loader.grub.forceInstall = true;
        boot.loader.grub.device = "nodev";
        boot.loader.timeout = 10;
      }
    )

  ];

}
