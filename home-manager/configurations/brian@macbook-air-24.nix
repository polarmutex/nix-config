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
    inputs.neovim-flake.packages.${pkgs.stdenv.hostPlatform.system}.neovim-polar
    anki-bin
  ];
}
