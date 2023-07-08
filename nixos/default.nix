{
  self,
  inputs,
  lib,
  ...
}: let
  nixosSystem = args:
    (lib.makeOverridable lib.nixosSystem)
    (lib.recursiveUpdate args {
      modules =
        args.modules
        ++ [
          {
            config.nixpkgs.pkgs = lib.mkDefault args.pkgs;
            config.nixpkgs.localSystem = lib.mkDefault args.pkgs.stdenv.hostPlatform;
          }
        ];
    });

  hosts = lib.rakeLeaves ./hosts;
  modules = lib.rakeLeaves ./modules;

  defaultModules = [
    # make flake inputs accessible in NixOS
    {
      _module.args.self = self;
      _module.args.inputs = inputs;
      _module.args.lib = lib;
    }
    # load common modules
    ({...}: {
      imports = [
        modules.core
        modules.doas
        modules.nix
        modules.openssh
      ];
    })
  ];

  pkgs.x86_64-linux = import inputs.nixpkgs {
    inherit lib;
    system = "x86_64-linux";
    config.allowUnfree = true;
  };
in {
  flake.nixosConfigurations = {
    polarbear = nixosSystem {
      pkgs = pkgs.x86_64-linux;
      modules =
        defaultModules
        ++ [
          modules.desktop
          modules.bluetooth
          modules.nvidia
          modules.display-manager
          modules.fonts
          modules.graphical
          modules.trusted
          modules.wm-helper
          modules.virt-manager
          modules.yubikey
        ]
        ++ [hosts.polarbear];
    };
    polarvortex = nixosSystem {
      pkgs = pkgs.x86_64-linux;
      modules =
        defaultModules
        ++ [
          modules.server
        ]
        ++ [hosts.polarvortex];
    };
  };
}
