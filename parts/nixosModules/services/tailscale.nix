{
  flake.nixosModules.tailscale = {
    services.tailscale.enable = true;
  };
}
