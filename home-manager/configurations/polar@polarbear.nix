{
  config,
  inputs,
  pkgs,
  self,
  ...
}: {
  home = {
    username = "polar";
    homeDirectory = "/home/polar";
  };

  home.packages = with pkgs; [
    asciidoctor
    cmake
    conan
    erdtree
    flameshot
    gcc
    nautilus
    gramps
    lazygit
    libreoffice-fresh
    inputs.neovim-flake.packages.${pkgs.system}.neovim-polar
    inputs.deploy-rs.packages.${system}.deploy-rs
    nix-diff
    npins
    #(netbeans.overrideAttrs (_: let
    #  nb_version = "18";
    #in {
    #  version = nb_version;
    #  src = fetchurl {
    #    url = "mirror://apache/netbeans/netbeans/${nb_version}/netbeans-${nb_version}-bin.zip";
    #    hash = "sha256-CTWOW1vd200oZZYqDRT4wqr4v5I3AAgEcqA/qi9Ief8=";
    #  };
    #}))
    netbeans
    netscanner
    # nix-melt
    nixpkgs-fmt
    peek
    self.packages.${pkgs.system}.wrapped-wezterm
    zoom-us
    zotero_7
    anki-bin
    ansible
  ];

  programs = {
    kitty.enable = true;
    kitty.textSize = 8;
  };

  sops = let
    user = builtins.getEnv "USER";
  in {
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    defaultSopsFile = ../../secrets/secrets.yaml;
    secrets.aoc_session_token = {
      path = "${config.home.homeDirectory}/.config/adventofcode.session";
    };
    secrets.git_config_work = {
      path = "${config.home.homeDirectory}/.config/work_email.session";
    };
  };
}
