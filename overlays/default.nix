inputs:
let
  # Pass flake inputs to overlay so we can use the sources pinned in flake.lock
  # instead of having to keep sha256 hashes in each package for src
  inherit inputs;
in
final: prev: {
  monolisa-font = prev.callPackage ../pkgs/monolisa-font { };
  #tree-sitter-beancount = super.callPackage ../pkgs/tree-sitter-beancount { };
  #tree-sitter-svelte = super.callPackage ../pkgs/tree-sitter-svelte { };
  fathom = prev.callPackage ../pkgs/fathom { };
  logseq = prev.callPackage ../pkgs/logseq { };
  #obsidian = super.callPackage ../pkgs/obsidian { };
  #dwm = super.callPackage ../pkgs/dwm { };
  #prettierd = prev.callPackage ../pkgs/prettierd { };
  stacks = prev.callPackage ../pkgs/stacks { };
  beancount-language-server = prev.callPackage ../pkgs/beancount-language-server { };
}
