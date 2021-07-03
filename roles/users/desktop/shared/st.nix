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
          rev = "8684c90a1d5a15491a52d763c5625c3479887df7";
          ref = "custom";
        };
        buildInputs = oldAttrs.buildInputs ++ [ pkgs.harfbuzz.dev ];
      });
    })
  ];

}
