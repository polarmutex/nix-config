{ pkgs, ... }:
with pkgs;
{
  jdtls = (callPackage ./jdt-language-server/default.nix {});
  tree-sitter-beancount = (
    callPackage ./tree-sitter-beancount/default.nix {}
  );
  fathom = (callPackage ./fathom/default.nix {});
  logseq = (callPackage ./logseq/default.nix {});
  obsidian = (callPackage ./obsidian/default.nix {});
  dwm = (callPackage ./dwm/default.nix {});
}
