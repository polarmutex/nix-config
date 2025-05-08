{pkgs, ...}: {
  home.packages = with pkgs; [
    devenv
    devcontainer
  ];
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
