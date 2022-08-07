{ pkgs, ... }: {
  imports = [
  ./direnv.nix
  ./nix.nix
  ./tmux.nix
  ./zsh.nix
  ];
  home.packages = with pkgs; [
    exa # Better ls
    ripgrep # Better grep
    fd # Better find
    jq # JSON pretty printer and manipulator
  ];
}
