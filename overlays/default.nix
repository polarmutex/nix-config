{ inputs }:
{
  # Adds my custom packages
  additions = final: _prev: import ../pkgs { pkgs = final; };

  # My wallpapers
  wallpapers = final: prev: {
    #wallpapers = final.callPackage ../pkgs/wallpapers { };
  };

  # Modifies existing packages
  modifications = final: prev: {
    awesome-git = (prev.awesome.overrideAttrs (old: rec {
      version = "master";
      src = inputs.awesome-git-src;
      patches = [ ];

      postPatch = ''
        patchShebangs tests/examples/_postprocess.lua
        patchShebangs tests/examples/_postprocess_cleanup.lua
      '';

      GI_TYPELIB_PATH = "${prev.playerctl}/lib/girepository-1.0:"
        + "${prev.upower}/lib/girepository-1.0:"
        + "${prev.networkmanager}/lib/girepository-1.0:"
        + old.GI_TYPELIB_PATH;
    })).override {
      gtk3Support = true;
    };
  };
}
