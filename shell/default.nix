{ self, inputs, ... }:
{
  modules = with inputs; [
  ];
  exportedModules = [
    ./polaros.nix
  ];
}

