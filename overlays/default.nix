inputs:
let
  # Pass flake inputs to overlay so we can use the sources pinned in flake.lock
  # instead of having to keep sha256 hashes in each package for src
  inherit inputs;
in
self: super: {
  monolisa-font = super.callPackage ../pkgs/monolisa-font { };
  jdtls = super.callPackage ../pkgs/jdt-language-server { };
  #tree-sitter-beancount = super.callPackage ../pkgs/tree-sitter-beancount { };
  #tree-sitter-svelte = super.callPackage ../pkgs/tree-sitter-svelte { };
  fathom = super.callPackage ../pkgs/fathom { };
  logseq = super.callPackage ../pkgs/logseq { };
  #obsidian = super.callPackage ../pkgs/obsidian { };
  #dwm = super.callPackage ../pkgs/dwm { };
  prettierd = super.callPackage ../pkgs/prettierd { };
  stacks = super.callPackage ../pkgs/stacks { };
  # TODO REMOVE WHEN FIXED
  sumneko-lua-language-server = super.sumneko-lua-language-server.overrideAttrs (old: rec {
    version = "3.2.1";
    src = super.fetchFromGitHub {
      owner = "sumneko";
      repo = "lua-language-server";
      rev = version;
      sha256 = "sha256-rxferVxTWmclviDshHhBmbCezOI+FvcfUW3gAkBQNHQ=";
      fetchSubmodules = true;
    };
  });
  beancount-language-server = super.callPackage ../pkgs/beancount-language-server { };
}
