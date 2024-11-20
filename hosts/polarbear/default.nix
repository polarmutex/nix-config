{
  config,
  inputs,
  lib,
  withSystem,
  mkNixos,
  ...
}: let
  system = "x86_64-linux";
  inherit (config.flake) nixosModules;
  defaultModules = [
    # make flake inputs accessible in NixOS
    {
      _module.args = {
        # inherit self;
        inherit inputs;
        inherit lib;
      };
    }
    # load common modules
    ({...}: {
      imports = [
        nixosModules.core
        nixosModules.doas
        nixosModules.nix
        nixosModules.openssh
      ];
    })
  ];
in {
  flake.nixosConfigurations.polarbear = withSystem system (_:
    mkNixos system (defaultModules
      ++ [
        ./configuration.nix
        nixosModules.desktop
        nixosModules.bluetooth
        nixosModules.nvidia
        inputs.hardware.nixosModules.common-hidpi
        inputs.hardware.nixosModules.common-cpu-intel-cpu-only
        inputs.hardware.nixosModules.common-gpu-nvidia-nonprime
        {
          # The open source driver does not support Maxwell GPUs.
          hardware.nvidia = {
            open = false;
            # prime = {
            #   # Bus ID of the Intel GPU.
            #   intelBusId = lib.mkDefault "PCI:0:2:0";
            #
            #   # Bus ID of the NVIDIA GPU.
            #   nvidiaBusId = lib.mkDefault "PCI:1:0:0";
            # };
          };
        }
        nixosModules.display-manager
        nixosModules.fonts
        nixosModules.graphical
        nixosModules.hyprland
        nixosModules.nix
        nixosModules.podman
        nixosModules.trusted
        nixosModules.wm-helper
        nixosModules.virt-manager
        nixosModules.yubikey
      ]));
}
