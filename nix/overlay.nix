{ deploy-rs
, neovim
, neovim-flake
, awesome-flake
  #, nixgl
, nixpkgs
, nur
, polarmutex-blog
, polar-dmenu
, polar-dwm
, polar-nur
, polar-st
, tmux-sessionizer
, ...
}:

let
  inherit (nixpkgs.lib) composeManyExtensions;
  inherit (builtins) attrNames readDir;
  localOverlays = map
    (f: import (./overlays + "/${f}"))
    (attrNames (readDir ./overlays));
in
composeManyExtensions (localOverlays ++ [
  #composeManyExtensions ([
  deploy-rs.overlay
  neovim.overlay
  neovim-flake.overlays.default
  awesome-flake.overlays.default
  polarmutex-blog.overlays.default
  #nixgl.overlay
  nur.overlay
  polar-nur.overlays.default
  polar-dwm.overlay
  polar-st.overlay
  polar-dmenu.overlay
  (import ./overlays/node-ifd.nix)
  (final: prev: {
    tmux-sessionizer = tmux-sessionizer.packages.${prev.system}.default;
  })
])
