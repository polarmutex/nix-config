{ pkgs, ... }: {
  imports = [
    ./gpg.nix
    ./mail.nix
    ./one-password.nix
  ];
  home.packages = with pkgs; [
  ];
}
