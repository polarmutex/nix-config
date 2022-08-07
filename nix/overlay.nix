{ deploy-rs
, neovim
, neovim-flake
  #, nixgl
, nixpkgs
, nur
, polar-dmenu
, polar-dwm
, polar-nur
, polar-st
, nix2vim
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
  neovim-flake.overlay
  # (final: _prev: {
  #   neovim-polar = neovim-flake.packages.${final.system}.default; #TODO still needed
  # })
  #nixgl.overlay
  nur.overlay
  polar-nur.overlays.default
  polar-dwm.overlay
  polar-st.overlay
  polar-dmenu.overlay
  nix2vim.overlay
  (import ./overlays/node-ifd.nix)
  (final: _prev: {
    neovim-polar = neovim-flake.packages.${final.system}.default;
  })
])
