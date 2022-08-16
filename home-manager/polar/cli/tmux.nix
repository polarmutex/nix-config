{ pkgs, config, lib, inputs, ... }:
with lib;
let
  tmux_sessionizer_old = pkgs.writeScriptBin "tmux-sessionizer" ''
    #!/usr/bin/env bash
    if [[ $# -eq 1 ]]; then
        selected=$1
    else
        selected=$(find ~/repos/personal ~/repos/work -mindepth 1 -maxdepth 1 -type d | fzf)
    fi
    if [[ -z $selected ]]; then
        exit 0
    fi
    selected_name=$(basename "$selected" | tr . _ | tr - _)
    tmux_running=$(pgrep tmux)
    if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
        tmux new-session -s $selected_name -c $selected
        exit 0
    fi
    if ! tmux has-session -t=$selected_name 2> /dev/null; then
        tmux new-session -ds $selected_name -c $selected
    fi
    if [[ -z $TMUX ]]; then
        tmux attach-session -t $selected_name
    else
        tmux switch-client -t $selected_name
    fi
  '';
in
{
  programs.tmux = {
    enable = true;
    sensibleOnTop = true;
    #terminal = "tmux-256color";
    escapeTime = 0;
    aggressiveResize = true;
    keyMode = "vi";
    shortcut = "a";
    baseIndex = 1;

    plugins = with pkgs; [
      {
        plugin = tmuxPlugins.gruvbox;
        extraConfig = "set -g @tmux-gruvbox 'dark'";
      }
      #{
      #  plugin = myTmuxPlugins.tokoyo-night-tmux;
      #  extraConfig = "set -g @plugin 'janoamaral/tokyo-night-tmux'";
      #}
    ];

    extraConfig = ''
      setw -g mouse on

      # for true color
      # Enable RGB colour if running in xterm(1)
      #set-option -sa terminal-overrides ",xterm*:Tc"
      # Change the default $TERM to tmux-256color
      set -g default-terminal "tmux-256color"
      #set -g default-terminal "xterm-256color"
      set -ag terminal-overrides ",tmux-256color:RGB"
    '';
  };

  home.packages = with pkgs; [
    tmux-sessionizer
  ];
}
