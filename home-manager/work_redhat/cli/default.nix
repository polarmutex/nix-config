{ pkgs, ... }: {
  imports = [
  ];
  home.packages = with pkgs; [
    ctop
    exa # Better ls
    #glab
    neovim-polar
    ripgrep # Better grep
    fd # Better find
    jq # JSON pretty printer and manipulator
  ];
}
