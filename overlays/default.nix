{ system, myPkgs, deploy-rs, neovim-nightly, polar-dwm, polar-st, polar-dmenu, nur, ... }:
{
  overlays = [
    deploy-rs.overlay
    neovim-nightly.overlay
    (final: prev: {
      inherit (polar-dwm.packages."${system}") dwm;
      inherit (polar-st.packages."${system}") st;
      inherit (polar-dmenu.packages."${system}") dmenu;
      inherit myPkgs;
    })
    nur.overlay
  ];
}

