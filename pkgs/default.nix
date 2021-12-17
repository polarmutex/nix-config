final: prev:
with prev;
let
  sources = prev.callPackage (import ./_sources/generated.nix) { };
in
{
  inherit sources;
  monolisafont =
    (callPackage ./fonts/monolisa.nix { });
  jdtls = (callPackage ./jdt-language-server/default.nix { });
  tree-sitter-beancount = (
    callPackage ./tree-sitter-beancount/default.nix { }
  );
  tree-sitter-svelte = (
    callPackage ./tree-sitter-svelte/default.nix { }
  );
  fathom = (callPackage ./fathom/default.nix { });
  logseq = callPackage ./apps/logseq { electron = final.electron_15; };
  obsidian = (callPackage ./obsidian/default.nix { });
  dwm = (callPackage ./dwm/default.nix { });
  prettierd = (callPackage ./prettierd/default.nix { });
}
