{ config, ... }:

rec {
  dot = path: "${config.home.homeDirectory}/repos/personal/nix-dotfiles/${path}";

  link-one = from: to: path:
    let
      paths = builtins.attrNames (
        { ${path} = "directory"; }
      );
      mkPath = path:
        let
          orig = "${from}/${path}";
        in
          {
            name = "${to}/${path}";
            value = {
              source = link orig;
            };
          };
    in
      builtins.listToAttrs (
        map mkPath paths
      );

  link-all = from: to:
    let
      paths = builtins.attrNames (
        builtins.readDir (../.. + "/${from}")
      );
      mkPath = path:
        let
          orig = "${from}/${path}";
        in
          {
            name = "${to}/${path}";
            value = {
              source = link orig;
            };
          };
    in
      builtins.listToAttrs (
        map mkPath paths
      );

  link = path:
    let
      fullpath = dot path;
    in
      config.lib.file.mkOutOfStoreSymlink fullpath;
}
