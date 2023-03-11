{
  pkgs,
  lib,
  ...
}: {
  users.users.polar = {
    uid = 1000;
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "libvirtd"];
    initialHashedPassword = "$6$p/7P2dlx4xBEV72W$Ooep2JnmTJhTnexObNtAt3CNqRIhqgA2cD4bZtWMXOYAP.yBig8XToII0Fxy2Kc/Q12gep7Uqfsq6wIxRv7f21";
    shell = pkgs.fish;
  };

  home-manager.users.polar = {
    profiles = {
      apps.enable = true;
      graphical = {
        eww.enable = true;
        messaging.enable = true;
        obsidian.enable = true;
        x11.enable = true;
        wallpaper.enable = true;
        wezterm.enable = true;
      };
      services.enable = true;
    };
    home.packages = with pkgs; [
      flameshot
      lazygit
      neovim-polar
      tmux-sessionizer
      tmux
    ];
  };
}
