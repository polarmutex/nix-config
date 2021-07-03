{ pkgs, home-manager, system, lib, overlays, ...}:
rec {
  host = import ./host.nix { inherit system pkgs home-manager lib user; };
  user = import ./user.nix { inherit system pkgs home-manager lib overlays; };
}
