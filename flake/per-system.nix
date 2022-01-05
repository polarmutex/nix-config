{ inputs, system }:

let
  config = {
    allowAliases = false;
    allowUnfree = true;
  };

  unstable = import inputs.nixpkgs-unstable {
    inherit config system;
  };

  polarOverlays = [
    inputs.dmenu.overlay
    inputs.dwm.overlay
    inputs.dwm-status.overlay
  ];

  overlays = [
    (final: prev: {
      inherit (unstable)
        # need bleeding edge version
        statix
        ;

      polar = prev.lib.composeManyExtensions polarOverlays final prev;
    })
  ];

  pkgs = import inputs.nixpkgs-stable {
    inherit config overlays system;
  };
in

{
  inherit pkgs;

  customLib = import (../lib) {
    inherit (inputs.nixpkgs-stable) lib;
    inherit pkgs;
  };
}
