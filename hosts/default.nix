{
  inputs,
  lib,
  withSystem,
  ...
}: {
  imports = [
    ./polarbear
    ./macbook-air-24
    ./polarvortex
  ];
  _module.args = let
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
    mkNixos = system: extraModules: let
      specialArgs =
        withSystem system
        ({
          inputs',
          self',
          ...
        }: {inherit self' inputs' inputs;});
    in
      inputs.nixpkgs-stable.lib.nixosSystem {
        inherit specialArgs;
        pkgs = pkgs.x86_64-linux;
        modules =
          [{}]
          ++ extraModules;
      };
    mkDarwin = system: extraModules: let
      specialArgs = withSystem system ({
        inputs',
        self',
        ...
      }: {inherit self' inputs' inputs;});
    in
      inputs.nix-darwin.lib.darwinSystem {
        inherit specialArgs;
        modules =
          [
            {
              nix = {
                settings = {
                  auto-optimise-store = true;
                  builders-use-substitutes = true;
                  experimental-features = ["nix-command" "flakes"];
                  trusted-users = ["@wheel"];
                  warn-dirty = false;
                };
              };
              programs.zsh.enable = true;
            }
          ]
          ++ extraModules;
      };
  };
}
