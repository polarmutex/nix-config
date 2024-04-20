{
  config,
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;
    package = pkgs.git;
    extraConfig = {
      # color.ui = true;
      credential.helper = "store";
      # push.autoSetupRemote = true;
    };
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
