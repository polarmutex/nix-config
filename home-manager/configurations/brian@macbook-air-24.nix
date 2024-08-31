{
  inputs,
  pkgs,
  ...
}: {
  home = {
    username = "brian";
    homeDirectory = "/Users/brian";
  };

  home.packages = with pkgs; [
    lazygit
    inputs.neovim-flake.packages.${pkgs.system}.neovim-polar
    anki-bin
  ];
}
