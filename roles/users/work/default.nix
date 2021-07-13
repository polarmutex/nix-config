{pkgs, config, ...}:
{
  home.sessionVariables = {
    GTK_IM_MODULE = "ibus";
    _JAVA_AWT_WM_NONREPARENTING = 1;
  };

  home.packages =  with pkgs; [
      vscode
      teams
  ];

  programs.zsh.profileExtra = ''export PATH=$HOME/netbeans-12.0/netbeans/bin:$PATH'';

  xsession = {
    profileExtra = ''
      compton &
      xrandr --dpi 163
    '';
  };
}
