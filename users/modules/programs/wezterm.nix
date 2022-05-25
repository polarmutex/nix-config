{ pkgs, config, lib, ... }:
with lib;
let
  #tmux_sessionizer = pkgs.writeScriptBin "tmux-sessionizer" ''
  #  #!/usr/bin/env bash

  #  if [[ $# -eq 1 ]]; then
  #      selected=$1
  #  else
  #      selected=$(find ~/repos/personal ~/repos/work -mindepth 1 -maxdepth 1 -type d | fzf)
  #  fi

  #  if [[ -z $selected ]]; then
  #      exit 0
  #  fi

  #  selected_name=$(basename "$selected" | tr . _ | tr - _)
  #  tmux_running=$(pgrep tmux)
  #  if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
  #      tmux new-session -s $selected_name -c $selected
  #      exit 0
  #  fi

  #  if ! tmux has-session -t=$selected_name 2> /dev/null; then
  #      tmux new-session -ds $selected_name -c $selected
  #  fi

  #  if [[ -z $TMUX ]]; then
  #      tmux attach-session -t $selected_name
  #  else
  #      tmux switch-client -t $selected_name
  #  fi
  #'';
  dot = path: "${config.home.homeDirectory}/repos/personal/nix-dotfiles/users/modules/programs/${path}";

  link = path:
    let
      fullpath = dot path;
    in
    config.lib.file.mkOutOfStoreSymlink fullpath;

  cfg = config.polar.programs.wezterm;
in
{
  ###### interface
  options = {

    polar.programs.wezterm = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable wezterm";
      };
    };
  };

  ###### implementation

  config = mkIf cfg.enable {
    home.sessionVariables.TERMINAL = "${pkgs.wezterm-git}/bin/wezterm start --always-new-process";
    xdg.configFile."wezterm/wezterm.lua".source = link "wezterm.lua";
  };
}
