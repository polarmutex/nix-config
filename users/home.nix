_:
{
  programs.home-manager.enable = true;
  home.sessionVariables = { EDITOR = "nvim"; };
  home.stateVersion = "20.09";

  imports = [
    ./modules/temp.nix
    ./modules/dwm.nix
    ./modules/work.nix
    ./modules/fonts.nix
    ./modules/programs/direnv.nix
    ./modules/programs/git.nix
    ./modules/programs/zsh.nix
    ./modules/programs/tmux.nix
    ./modules/programs/neomutt.nix
    ./modules/programs/neovim.nix
    ./modules/programs/firefox/firefox.nix
    ./modules/services/dunst.nix
    ./modules/services/picom.nix
    ./modules/services/logseq.nix
    ./modules/services/dendron.nix
    ./modules/services/stacks.nix
    ./modules/services/spotify.nix
    ./modules/services/obsidian.nix
    ./modules/services/protonvpn.nix
    ./modules/services/dwm-status.nix
    ./modules/services/wallpapers.nix
    ./modules/services/gpg/default.nix
  ];
}
