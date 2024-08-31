{pkgs, ...}: {
  programs.chromium = {
    enable = true;
    package = pkgs.brave;
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
