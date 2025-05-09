{
  pkgs,
  # lib,
  ...
}: let
  myGit = pkgs.gitFull;
  gitconfig =
    builtins.readFile ./gitconfig
    + ''
      [includeIf "gitdir:~/repos/work/"]
        path = "/run/secrets/git_config_work";
    '';
in {
  wrappers.git = {
    basePackage = myGit;
    extraPackages = [
      pkgs.git-extras
      myGit
    ];
    env.GIT_CONFIG_GLOBAL.value = builtins.toFile "gitconfig" gitconfig;
  };
}
