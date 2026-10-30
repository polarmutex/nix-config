{
  flake.wrappers.obsidian-polar = {
    pkgs,
    lib,
    wlib,
    ...
  }: {
    imports = [wlib.modules.default];

    config = {
      # insider asar needs a newer electron than nixpkgs' default
      package = pkgs.unstable.obsidian.override {electron = pkgs.unstable.electron_44;};

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
