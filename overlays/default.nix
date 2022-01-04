{ system, myPkgs, deploy-rs, neovim-nightly, polar-dwm, polar-st, polar-dmenu, nur, ... }:
{
  overlays = [
    deploy-rs.overlay
    neovim-nightly.overlay
    (final: prev: {
      dwm = polar-dwm.packages.${system}.dwm;
      st = polar-st.packages.${system}.st;
      dmenu = polar-dmenu.packages.${system}.dmenu;
      inherit myPkgs;
    })
    nur.overlay
  ];
}

