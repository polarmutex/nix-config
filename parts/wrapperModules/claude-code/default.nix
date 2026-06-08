{
  flake.wrappers.claude-code-polar = {wlib, ...}: {
    imports = [wlib.wrapperModules.claude-code ./_shared.nix];
  };
}
