{ pkgs, config, ... }:
{
  home.sessionVariables = {
    GTK_IM_MODULE = "ibus";
    _JAVA_AWT_WM_NONREPARENTING = 1;
  };

  home.packages = with pkgs; [
    vscode
    teams
    cmake
    brave
  ];

  programs.zsh.initExtra = ''
  export PATH=$HOME/netbeans-12.0/netbeans/bin:$PATH
  export JDTLS_HOME=$HOME/jdtls
  '';

  xsession = {
    profileExtra = ''
      compton &
      xrandr --dpi 163
    '';
  };
}
