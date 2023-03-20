{
  self,
  inputs,
  config,
  lib,
  ...
}: let
  cfg = config.polar.nixosConfigurations;

  configs = builtins.mapAttrs (_: config: config.finalSystem) cfg;

  packages = builtins.attrValues (builtins.mapAttrs (_: config: config.packageModule) cfg);
in {
  options = {
    polar.nixosConfigurations = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule ({
        name,
        config,
        ...
      }: {
        options = {
          nixpkgs = lib.mkOption {
            type = lib.types.unspecified;
            default = inputs.nixpkgs;
          };
          system = lib.mkOption {type = lib.types.enum ["x86_64-linux" "aarch64-linux"];};

          modules = lib.mkOption {
            type = lib.types.listOf lib.types.unspecified;
            default = [];
          };

          entryPoint = lib.mkOption {
            type = lib.types.unspecified;
            readOnly = true;
          };

          finalModules = lib.mkOption {
            type = lib.types.listOf lib.types.unspecified;
            readOnly = true;
          };

          configFolder = lib.mkOption {
            type = lib.types.str;
            readOnly = true;
          };

          finalSystem = lib.mkOption {
            type = lib.types.unspecified;
            readOnly = true;
          };

          packageName = lib.mkOption {
            type = lib.types.str;
            readOnly = true;
          };

          finalPackage = lib.mkOption {
            type = lib.types.package;
            readOnly = true;
          };

          packageModule = lib.mkOption {
            type = lib.types.unspecified;
            readOnly = true;
          };
        };

        config = {
          configFolder = "${self}/nixos/configurations";
          entryPoint = import "${config.configFolder}/${name}" (inputs // {inherit self;});

          finalModules =
            [
              {boot.cleanTmpDir = true;}
              {networking.hostName = name;}
              {nix.flakes.enable = true;}
              {system.configurationRevision = self.rev or "dirty";}
              {documentation.man.enable = true;}
              {documentation.man.generateCaches = true;}
              inputs.sops-nix.nixosModules.sops
            ]
            ++ config.modules
            ++ builtins.attrValues {
              inherit (config) entryPoint;
            }
            ++ builtins.attrValues self.nixosModules;

          packageName = "nixos/config/${name}";
          finalPackage = config.finalSystem.config.system.build.toplevel;

          packageModule = {${config.system}.${config.packageName} = config.finalPackage;};

          finalSystem = config.nixpkgs.lib.nixosSystem {
            inherit (config) system;

            modules = config.finalModules;
          };
        };
      }));
    };
  };

  config.flake.nixosConfigurations = configs;
  config.flake.packages = lib.mkMerge packages;
}
