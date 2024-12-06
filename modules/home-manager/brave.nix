{...}: {
  programs.brave = {
    enable = true;
    # package = pkgs.unstable-small.brave;
    extensions = [
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
      "dbepggeogbaibhgnhhndojpepiihcmeb" # Vimium.
      #"eimadpbcbfnmbkopoojfekhnkhdbieeh" # Dark Reader
      "fihnjjcciajhdojfnbdddfaoknhalnja" # I don't care about cookies
      "kbfnbcaeplbcioakkpcpgfkobkghlhen" # Grammarly
      "aeblfdkhhhdcdjpifhhbdiojplfjncoa" #1password
    ];
  };
}
