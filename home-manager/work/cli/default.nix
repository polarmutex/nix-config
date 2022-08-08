{ pkgs, ... }: {
  imports = [
    ../../polar/cli/direnv.nix
    ./git.nix
    ../../polar/cli/htop.nix
    ../../polar/cli/nix.nix
    ../../polar/cli/tmux.nix
    ../../polar/cli/zsh.nix
  ];
  home.packages = with pkgs; [
    exa # Better ls
    neovim-polar
    ripgrep # Better grep
    fd # Better find
    jq # JSON pretty printer and manipulator
  ];
}
