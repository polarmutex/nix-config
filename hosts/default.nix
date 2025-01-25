{
  inputs,
  withSystem,
  ...
}: {
  imports = [
    ./polarbear
    ./macbook-air-24
    ./polarvortex
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
      inputs.nixpkgs-stable.lib.nixosSystem {
        inherit specialArgs;
        pkgs = withSystem system ({pkgs-stable, ...}: pkgs-stable);
        modules =
          [
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
                  trusted-users = ["@wheel" "brian"];
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
