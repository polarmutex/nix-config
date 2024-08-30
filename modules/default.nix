{config, ...}: {
  flake.nixosModules =
    config.flake.lib.rakeLeaves ./nixos;
}
