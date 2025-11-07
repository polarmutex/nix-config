{
  # config,
  inputs,
  withSystem,
  ...
}: {
  imports = [
    ./polarbear
    ./macbook-air-24
    ./polarvortex
    # ./vm-intel
  ];
  _module.args = {
    mkNixos = system: extraModules: let
      specialArgs =
        withSystem system
        ({
          inputs',
          self',
          ...
        }: {inherit self' inputs' inputs;});
    in
      inputs.nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        pkgs = withSystem system ({pkgs, ...}: pkgs);
        modules =
          [
            inputs.sops-nix.nixosModules.sops
            inputs.noshell.nixosModules.default
            {
              programs.noshell.enable = true;
            }
          ]
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
                  trusted-users = ["@wheel" "polar"];
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
