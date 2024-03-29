{
  self,
  inputs,
  lib,
  ...
}: let
  hosts = lib.rakeLeaves ./hosts;
  modules = lib.rakeLeaves ./modules;

  defaultModules = [
    # make flake inputs accessible in NixOS
    {
      _module.args = {
        inherit self;
        inherit inputs;
        inherit lib;
      };
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

  pkgs.x86_64-linux = import inputs.nixpkgs-stable {
    inherit lib;
    system = "x86_64-linux";
    config.allowUnfree = true;
    # Enable the unfree packages
    config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "broadcom-sta"
        "corefonts"
        "1password-gui"
        "1password-cli"
        "1password"
        "nvidia-settings"
        "nvidia-x11"
      ];
    overlays = [
      (_final: prev: {
        unstable = import inputs.nixpkgs {
          inherit (prev) system;
          config.allowUnfree = true;
        };
      })
    ];
  };
in {
  flake.nixosConfigurations = {
    polarbear = inputs.nixpkgs-stable.lib.nixosSystem {
      pkgs = pkgs.x86_64-linux;
      system = "x86_64-linux";
      modules =
        defaultModules
        ++ [
          modules.desktop
          modules.bluetooth
          modules.nvidia
          modules.display-manager
          modules.fonts
          modules.graphical
          modules.nix
          modules.podman
          modules.trusted
          modules.wm-helper
          modules.virt-manager
          modules.yubikey
        ]
        ++ [hosts.polarbear];
    };
    polarvortex = inputs.nixpkgs-stable.lib.nixosSystem {
      system = "x86_64-linux";
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
