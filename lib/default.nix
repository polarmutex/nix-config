{lib, ...}: let
  # mkLib = self: let
  #   importLib = file: import file ({inherit self;} // args);
  # in {
  #   attrs = importLib ./attrs.nix;
  #   formats = importLib ./formats.nix;
  #   importers = importLib ./importers.nix;
  #   options = importLib ./options.nix;
  #
  #   inherit (self.attrs) mergeAny;
  #   inherit (self.importers) rakeLeaves flattenTree;
  #   inherit (self.options) mkEnableOpt' mkOpt mkOptStr mkBoolOpt;
  # };
in
  # lib.makeExtensible mkLib
  {
    flake.lib = rec {
      rakeLeaves =
        /*
        *
        Synopsis: rakeLeaves _path_
        Recursively collect the nix files of _path_ into attrs.
        Output Format:
        An attribute set where all `.nix` files and directories with `default.nix` in them
        are mapped to keys that are either the file with .nix stripped or the folder name.
        All other directories are recursed further into nested attribute sets with the same format.
        Example file structure:
        ```
        ./core/default.nix
        ./base.nix
        ./main/dev.nix
        ./main/os/default.nix
        ```
        Example output:
        ```
        {
        core = ./core;
        base = base.nix;
        main = {
            dev = ./main/dev.nix;
            os = ./main/os;
          };
        }
        ```
        *
        */
        dirPath: let
          seive = file: type:
          # Only rake `.nix` files or directories
            (type == "regular" && lib.hasSuffix ".nix" file) || (type == "directory");

          collect = file: type: {
            name = lib.removeSuffix ".nix" file;
            value = let
              path = dirPath + "/${file}";
            in
              if
                (type == "regular")
                || (type == "directory" && builtins.pathExists (path + "/default.nix"))
              then path
              # recurse on directories that don't contain a `default.nix`
              else rakeLeaves path;
          };

          files = lib.filterAttrs seive (builtins.readDir dirPath);
        in
          lib.filterAttrs (_: v: v != {}) (lib.mapAttrs' collect files);
    };
  }
