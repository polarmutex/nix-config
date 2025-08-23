{
  pkgs,
  # lib,
  ...
}: let
  gitconfig = builtins.toFile "gitconfig" (
    (builtins.readFile ./gitconfig)
    +
    # gitconfig
    ''
      [includeIf "gitdir:~/repos/work/"]
        path = "/run/secrets/git_config_work";
    ''
  );
in {
  wrappers.git-polar = {
    basePackage = pkgs.unstable.git.overrideAttrs (old: {
      passthru =
        (old.passhtru or {})
        // {
          inherit gitconfig;
        };
    });
    extraPackages = [
      pkgs.unstable.git-extras
      pkgs.unstable.git-graph
      # myGit
    ];
    env.GIT_CONFIG_GLOBAL.value = gitconfig;
  };
}
