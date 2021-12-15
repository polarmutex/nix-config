channels: final: prev: {

  __dontExport = true; # overrides clutter up actual creations

  inherit (channels.latest)
    cachix
    discord
    element-desktop
    nixpkgs-fmt
    qutebrowser
    starship
    deploy-rs
    ;
}
