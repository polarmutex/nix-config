{pkgs, config, lib, ...}:
{
  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    escapeTime = 0;
    aggressiveResize = true;
    keyMode = "vi";
    shortcut = "a";

    extraConfig = ''
      setw -g mouse on
    '';
  };
}
