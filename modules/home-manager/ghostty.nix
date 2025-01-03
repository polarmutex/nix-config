{
  inputs,
  pkgs,
  ...
}: {
  home.packages = [inputs.ghostty.packages.${pkgs.system}.default];
  xdg.configFile."ghostty/config".text = ''
    theme = kanagawa-wave
    background-opacity = 0.95
    cursor-style = bar
    window-padding-x = 4,4
    gtk-titlebar = false

    window-save-state = always

    font-family = Monolisa
    font-size = 11
  '';
}
