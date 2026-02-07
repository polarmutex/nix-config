{
  flake.wrappers.git-polar = {
    config,
    pkgs,
    lib,
    wlib,
    ...
  }: {
    imports = [wlib.wrapperModules.git];
    config = {
      package = pkgs.unstable.git;

      # Declarative git configuration
      settings = {
        core.fsmonitor = true;
        credential.helper = "libsecret";
        credential."https://github.com".helper = ["" "!gh auth git-credential"];
        credential."https://gist.github.com".helper = ["" "!gh auth git-credential"];
        user = {
          email = "brian@brianryall.xyz";
          name = "Brian Ryall";
        };
      };

      # Additional config for work-specific settings via sops
      configFile.content = lib.mkAfter ''
        # vim ft=gitconfig
        [core]
          fsmonitor = true
        [credential]
          helper = libsecret
        [credential "https://github.com"]
          helper=
          helper=!gh auth git-credential
        [credential "https://gist.github.com"]
          helper=
          helper=!gh auth git-credential
        [user]
          email=brian@brianryall.xyz
          name=Brian Ryall
        [includeIf "gitdir:~/repos/work/"]
          path = "/run/secrets/git_config_work"
      '';

      passthru.gitconfig = config.configFile.path;

      prefixVar = [
        [
          "PATH"
          ":"
          (lib.makeBinPath [
            pkgs.unstable.git-extras
            pkgs.unstable.git-graph
          ])
        ]
      ];
    };
  };
}
