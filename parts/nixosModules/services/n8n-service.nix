{
  flake.nixosModules.n8n-service = {pkgs, ...}: let
    sources = import ../../../npins;
  in {
    disabledModules = ["services/misc/n8n.nix"];
    imports = ["${sources.nixpkgs-unstable}/nixos/modules/services/misc/n8n.nix"];
    services.n8n = {
      enable = true;
      package = pkgs.unstable.n8n;
    };
  };
}
