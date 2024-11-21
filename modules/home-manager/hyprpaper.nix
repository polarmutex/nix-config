{
  inputs,
  pkgs,
  ...
}: {
  services.hyprpaper = {
    enable = true;
    package = inputs.hyprpaper.packages.${pkgs.system}.default;
    settings = {
      ipc = "on";
      preload = [
        # (builtins.toString wallpaper)
      ];

      wallpaper = [
        # "DP-1,${builtins.toString wallpaper}"
        # "DP-2,${builtins.toString wallpaper}"
      ];
    };
  };
}
