{
  inputs,
  pkgs,
  ...
}: {
  #nixpkgs.allowedUnfree = [
  #  "discord"
  #  "obsidian"
  #  "1password"
  #  "onepassword-password-manager"
  #];

  #activeProfiles = [
  #  "base"
  #  "fonts"
  #  "messaging"
  #  "trusted"
  #  "wallpapers"
  #];
  #profiles.base.enable = true;

  programs = {
    kitty.enable = true;
    kitty.textSize = 11;
    wezterm.enable = true;
  };

  #xsession.windowManager.awesome.enable = true;

  home.packages = with pkgs; [
    cmake
    conan
    erdtree
    flameshot
    gcc
    gnome.nautilus
    gramps
    lazygit
    inputs.neovim-flake.packages.${pkgs.system}.neovim-polar
    #(netbeans.overrideAttrs (_: let
    #  nb_version = "18";
    #in {
    #  version = nb_version;
    #  src = fetchurl {
    #    url = "mirror://apache/netbeans/netbeans/${nb_version}/netbeans-${nb_version}-bin.zip";
    #    hash = "sha256-CTWOW1vd200oZZYqDRT4wqr4v5I3AAgEcqA/qi9Ief8=";
    #  };
    #}))
    (netbeans.override {jdk = pkgs.jdk11;})
    nix-melt
    nixpkgs-fmt
    zoom-us
    zotero
  ];
}
