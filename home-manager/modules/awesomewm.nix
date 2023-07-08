{
  inputs,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [rofi];

  xdg.configFile.awesome.source = inputs.awesome-flake.packages.${pkgs.system}.awesome-config-polar;
}
