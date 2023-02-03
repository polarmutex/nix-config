{
  inputs,
  self,
  pkgs,
  lib,
  ...
}: {
  home-manager = {
    extraSpecialArgs = {
      inherit self inputs pkgs;
      lib = lib.extend (_: _: inputs.home-manager.lib);
    };
    sharedModules = lib.flatten [
      {
        programs.home-manager.enable = true;
        # home-manager.useGlobalPkgs = true;
        # home-manager.useUserPackages = true;
        home.stateVersion = "21.11";
      }
      (with lib; collectLeaves ../../home-manager/modules)
      (args: {
        imports = lib.genModules args "profiles" ../../home-manager/profiles;
      })
    ];
  };
}
