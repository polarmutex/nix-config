{ pkgs, ... }:
{

  # assume awesome-git installed in nixos
  home.file = {
    ".config/awesome".source = "${pkgs.awesome-config-polar}";
  };

  home.packages = with pkgs; [
    rofi
  ];

}
