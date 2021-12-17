{ config, pkgs, lib, ... }:
{

  home.packages = with pkgs; [
    starship
    fzf
  ];

  # Prompt configuration
  #home.file = {
  #  "starship.toml" = {
  #    source = ./starship.toml;
  #    target = ".config/starship.toml";
  #  };
  #};

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    autocd = true;
    dotDir = ".config/zsh";

    initExtraBeforeCompInit = ''
      # Set bigger history size
      export HISTFILESIZE=1000000000
      export HISTSIZE=1000000000
      # Setup history to ignore lines starting with
      # space and duplicates.
      setopt autocd
      setopt append_history
      setopt hist_ignore_dups
      setopt hist_ignore_space
      export HISTTIMEFORMAT="[%F %T] "
      setopt EXTENDED_HISTORY
      # Simple keybindings for moving around commands in history.
      bindkey -e      
      bindkey "$terminfo[khome]" beginning-of-line # Home
      bindkey "$terminfo[kend]" end-of-line # End
      bindkey "$terminfo[kich1]" overwrite-mode # Insert
      bindkey "$terminfo[kdch1]" delete-char # Delete
      bindkey "$terminfo[kcuu1]" up-line-or-history # Up
      bindkey "$terminfo[kcuu1]" up-line-or-history # Up
      bindkey "$terminfo[kcub1]" backward-char # Left
      bindkey "$terminfo[kcuf1]" forward-char # Right
      autoload -U up-line-or-beginning-search
      autoload -U down-line-or-beginning-search
      zle -N up-line-or-beginning-search
      zle -N down-line-or-beginning-search
      bindkey "^[[A" up-line-or-beginning-search # Up
      bindkey "^[[B" down-line-or-beginning-search # Down
      eval "$(direnv hook zsh)"
    '';
    initExtra = ''
      eval "$(starship init zsh)"
    '';

    history = {
      expireDuplicatesFirst = true;
      ignoreSpace = false;
      save = 15000;
      share = true;
    };

    shellAliases = {

      # Exa ls replacement
      ls = "${pkgs.exa}/bin/exa --group-directories-first";
      l = "${pkgs.exa}/bin/exa -lbF --git --group-directories-first --icons";
      ll = "${pkgs.exa}/bin/exa -lbGF --git --group-directories-first --icons";
      llm =
        "${pkgs.exa}/bin/exa -lbGd --git --sort=modified --group-directories-first --icons";
      la =
        "${pkgs.exa}/bin/exa -lbhHigmuSa --time-style=long-iso --git --color-scale --group-directories-first --icons";
      lx =
        "${pkgs.exa}/bin/exa -lbhHigmuSa@ --time-style=long-iso --git --color-scale --group-directories-first --icons";
      lt =
        "${pkgs.exa}/bin/exa --tree --level=2 --group-directories-first --icons";

      c = "${pkgs.bat}/bin/bat -n --decorations never";
      cc =
        "${pkgs.clang}/bin/clang -Wall -Wextra -pedantic -std=c99 -Wshadow -Weverything";
    };

  };
}
