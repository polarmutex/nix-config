{ lib, pkgs, ... }: {
  home = {
    packages = with pkgs; [
      nix-update
      nixpkgs-review
    ];
  };

  programs = {
    gh = {
      enable = true;
      settings.git_protocol = "ssh";
    };

    nix-index.enable = true;
  };
}
