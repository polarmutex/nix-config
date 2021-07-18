{ pkgs, ... }:
with pkgs;
{
  jdt-language-server = (callPackage ./jdt-language-server/default.nix {});
  tree-sitter-beancount = (
    callPackage ./tree-sitter-beancount/default.nix {}
  );
}
