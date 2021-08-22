{ pkgs, ... }:
{
  fonts.fontconfig.enable = true;
  home.packages = [
    (pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];

  home.file.".local/share/fonts/MonoLisa-Regular.otf".source = ../../.secrets/MonoLisa-Regular.otf;
  home.file.".local/share/fonts/MonoLisa-Bold.otf".source = ../../.secrets/MonoLisa-Bold.otf;
  home.file.".local/share/fonts/MonoLisa-BoldItalic.otf".source = ../../.secrets/MonoLisa-BoldItalic.otf;
  home.file.".local/share/fonts/MonoLisa-RegularItalic.otf".source = ../../.secrets/MonoLisa-RegularItalic.otf;
}
