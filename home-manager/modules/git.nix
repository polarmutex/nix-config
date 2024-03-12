{
  config,
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;
    package = pkgs.git;
    includes = [
      {
        condition = "gitdir:~/repos/personal/";
        contents = {
          user = {
            name = "Brian Ryall";
            email = "me@brianryall.xyz";
            # signingkey = "";
          };
          # gpg.format = "ssh";
        };
      }
      {
        condition = "gitdir:~/repos/work/";
        inherit (config.sops.secrets.git_config_work) path;
      }
    ];
  };
}
