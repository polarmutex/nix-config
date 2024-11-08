{
  inputs,
  lib,
  ...
}: {
  perSystem = {system, ...}: {
    _module.args = let
      config = {
        allowUnfreePredicate = pkg: let
          pname = lib.getName pkg;
          byName = builtins.elem pname [
            "1password"
            "1password-cli"
            "broadcom-sta"
            "corefonts"
            "discord"
            "prismlauncher"
            "nvidia-x11"
            "nvidia-settings"
            "obsidian"
            "steam"
            "steam-original"
            "symbola"
            "vagrant"
            "zoom"
            # "google-chrome"
          ];
          byLicense = builtins.elem pkg.meta.license.shortName [
            # "CUDA EULA"
            # "bsl11"
          ];
        in
          if byName || byLicense
          then lib.warn "Allowing unfree package: ${pname}" true
          else false;
      };
    in {
      pkgs = import inputs.nixpkgs {
        inherit config system;
        overlays = [
        ];
      };
      pkgs-stable = import inputs.nixpkgs-stable {
        inherit config system;
        overlays = [
          (_final: prev: {
            unstable = import inputs.nixpkgs {
              inherit (prev) system;
              inherit config;
            };
          })
        ];
      };
    };

    packages = {
    };
  };
}
