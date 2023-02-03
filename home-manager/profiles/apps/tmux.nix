{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
with lib; let
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
in {
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
      #{
      #  plugin = tmuxPlugins.gruvbox;
      #  extraConfig = "set -g @tmux-gruvbox 'dark'";
      #}
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
      # TokyoNight colors for Tmux
      set -g mode-style "fg=#7aa2f7,bg=#3b4261"
      set -g message-style "fg=#7aa2f7,bg=#3b4261"
      set -g message-command-style "fg=#7aa2f7,bg=#3b4261"
      set -g pane-border-style "fg=#3b4261"
      set -g pane-active-border-style "fg=#7aa2f7"
      set -g status "on"
      set -g status-justify "left"
      set -g status-style "fg=#7aa2f7,bg=#1f2335"
      set -g status-left-length "100"
      set -g status-right-length "100"
      set -g status-left-style NONE
      set -g status-right-style NONE
      set -g status-left "#[fg=#15161E,bg=#7aa2f7,bold] #S #[fg=#7aa2f7,bg=#1f2335,nobold,nounderscore,noitalics]"
      set -g status-right "#[fg=#1f2335,bg=#1f2335,nobold,nounderscore,noitalics]#[fg=#7aa2f7,bg=#1f2335] #{prefix_highlight} #[fg=#3b4261,bg=#1f2335,nobold,nounderscore,noitalics]#[fg=#7aa2f7,bg=#3b4261] %Y-%m-%d  %I:%M %p #[fg=#7aa2f7,bg=#3b4261,nobold,nounderscore,noitalics]#[fg=#15161E,bg=#7aa2f7,bold] #h "
      setw -g window-status-activity-style "underscore,fg=#a9b1d6,bg=#1f2335"
      setw -g window-status-separator ""
      setw -g window-status-style "NONE,fg=#a9b1d6,bg=#1f2335"
      setw -g window-status-format "#[fg=#1f2335,bg=#1f2335,nobold,nounderscore,noitalics]#[default] #I  #W #F #[fg=#1f2335,bg=#1f2335,nobold,nounderscore,noitalics]"
      setw -g window-status-current-format "#[fg=#1f2335,bg=#3b4261,nobold,nounderscore,noitalics]#[fg=#7aa2f7,bg=#3b4261,bold] #I  #W #F #[fg=#3b4261,bg=#1f2335,nobold,nounderscore,noitalics]"
    '';
  };

  home.packages = with pkgs; [
    tmux-sessionizer
  ];
}
