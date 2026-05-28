{
  flake.wrappers.obsidian-polar = {
    pkgs,
    lib,
    wlib,
    ...
  }: {
    imports = [wlib.modules.default];

    config = {
      package = pkgs.unstable.obsidian;

      prefixVar = [
        [
          "PATH"
          ":"
          (lib.makeBinPath [
            pkgs.python3
            pkgs.unstable.bun
          ])
        ]
      ];
    };
  };
}
