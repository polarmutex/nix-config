{config, ...}: {
  flake = {
    nixosModules =
      config.flake.lib.rakeLeaves ./nixos;
    homeManagerModules =
      config.flake.lib.rakeLeaves ./home-manager;
    darwinModules = [];
  };
}
