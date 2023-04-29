{
  inputs,
  pkgs,
  ...
}: {
  polar.homeConfigurations."polar@polarbear".system = "x86_64-linux";
  polar.homeConfigurations."polar@polarbear".modules = [
    (import inputs.rycee {inherit pkgs;}).hmModules.emacs-init
  ];
  polar.homeConfigurations."user@work".system = "x86_64-linux";

  #homeConfigurations = withSystem "x86_64-linux" ({pkgs, ...}: {
  #  work = homeManagerConfiguration {
  #    modules =
  #      [
  #        {
  #          home.username = "user";
  #          home.homeDirectory = "/home/user";
  #          home.packages = with pkgs; [
  #            ctop
  #            fd
  #            glab
  #            lazygit
  #            #lens # need openlens
  #            #kube3d
  #            #kubectl
  #            #kubernetes-helm
  #            neovim-polar
  #            ripgrep
  #            tmux
  #            tmux-sessionizer
  #          ];
  #          profiles = {
  #            apps.direnv.enable = true;
  #            apps.helix.enable = true;
  #            apps.fish.enable = true;
  #            apps.tmux.enable = true;
  #            graphical.fonts.enable = true;
  #            graphical.wezterm.enable = true;
  #            graphical.obsidian.enable = true;
  #          };
  #          home.sessionPath = [
  #            "$HOME/.local/bin"
  #          ];
  #        }
  #      ]
  #      ++ sharedModules;
  #    inherit pkgs;
  #    extraSpecialArgs = {
  #      inherit self inputs pkgs;
  #      #lib = lib.extend (_: _: inputs.home-manager.lib);
  #    };
  #  };
  #});
}
