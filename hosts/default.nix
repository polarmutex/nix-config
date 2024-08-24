{
  inputs,
  config,
  withSystem,
  ...
}: {
  imports = [
    ./macbook-air-24
  ];
  _module.args.mkDarwin = system: extraModules: let
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
}
