{ pkgs, config, lib, overlays, ...}:
{

  home.sessionVariables = {
    TERMINAL = "${pkgs.st}/bin/st";
  };

  home.packages = with pkgs; [
    st
  ];

  nixpkgs.overlays = [
    (self: super: {
      st = super.st.overrideAttrs( oldAttrs : rec {
        src = builtins.fetchGit {
          url = "https://github.com/polarmutex/st";
          rev = "24f3e924bbef78bac40ae8c3da8b2b832f809ff7";
          ref = "custom";
        };
        buildInputs = oldAttrs.buildInputs ++ [ pkgs.harfbuzz.dev ];
      });
    })
  ];

}
