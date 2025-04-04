{
  inputs,
  lib,
  ...
}: {
  perSystem = {system, ...}: {
    _module.args = let
      config = {
        permittedInsecurePackages = [
          "electron-32.3.3"
        ];
        allowUnfreePredicate = pkg: let
          pname = lib.getName pkg;
          byName = builtins.elem pname [
            "1password"
            "1password-cli"
            "broadcom-sta"
            "corefonts"
            "discord"
            "prismlauncher"
            "morgen"
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
          (import inputs.rust-overlay)
          (_final: prev: {
            # unstable-small = import inputs.nixpkgs-small {
            #   inherit (prev) system;
            #   inherit config;
            # };
          })
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
