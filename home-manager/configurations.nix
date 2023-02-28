{
  inputs,
  withSystem,
  self,
  lib,
  ...
}: let
  inherit (self.lib) importModules collectLeaves genModules genHosts;
  sharedModules = lib.flatten [
    {
      programs.home-manager.enable = true;
      # home-manager.useGlobalPkgs = true;
      # home-manager.useUserPackages = true;
      home.stateVersion = "21.11";
    }
    (with lib; collectLeaves ./modules)
    (args: {
      imports = genModules args "profiles" ./profiles;
    })
  ];
  inherit
    (inputs.home-manager.lib)
    homeManagerConfiguration
    ;
in {
  flake = {
    homeConfigurations = withSystem "x86_64-linux" ({pkgs, ...}: {
      work = homeManagerConfiguration {
        modules =
          [
            {
              home.username = "user";
              home.homeDirectory = "/home/user";
              home.packages = with pkgs; [
                ctop
                fd
                glab
                lazygit
                kube3d
                kubectl
                kubernetes-helm
                neovim-polar
                ripgrep
                tmux
                tmux-sessionizer
              ];
              profiles = {
                apps.direnv.enable = true;
                apps.helix.enable = true;
                apps.fish.enable = true;
                apps.tmux.enable = true;
                graphical.fonts.enable = true;
                graphical.wezterm.enable = true;
                graphical.obsidian.enable = true;
              };
              home.sessionPath = [
                "$HOME/.local/bin"
              ];
            }
          ]
          ++ sharedModules;
        inherit pkgs;
        extraSpecialArgs = {
          inherit self inputs pkgs;
          #lib = lib.extend (_: _: inputs.home-manager.lib);
        };
      };
    });
  };
}
