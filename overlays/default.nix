inputs:
let
  # Pass flake inputs to overlay so we can use the sources pinned in flake.lock
  # instead of having to keep sha256 hashes in each package for src
  inherit inputs;
in
self: super: {
  my = {
    jdtls = super.callPackage ../pkgs/jdt-language-server {};
    tree-sitter-beancount = super.callPackage ../pkgs/tree-sitter-beancount {};
    fathom = super.callPackage ../pkgs/fathom {};
    logseq = super.callPackage ../pkgs/logseq {};
    obsidian = super.callPackage ../pkgs/obsidian {};
  };
}
