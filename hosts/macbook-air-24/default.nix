{
  config,
  mkDarwin,
  withSystem,
  ...
}: let
  system = "aarch64-darwin";
in {
  flake.darwinConfigurations."Ryalls-MacBook-Air" = withSystem system (
    {pkgs, ...}:
      mkDarwin system [
        {
          nixpkgs.hostPlatform = "aarch64-darwin";
          services.nix-daemon.enable = true;
          environment.systemPackages = with pkgs; [
            iterm2
            mas
          ];
          homebrew.enable = true;
          homebrew.onActivation.autoUpdate = true;
          homebrew.onActivation.upgrade = true;
          homebrew.casks = [
            "backblaze"
            "brave-browser"
            "firefox"
            "istat-menus"
            "google-chrome"
            "spotify"
          ];
          homebrew.masApps = {
            "1password for safari" = 1569813296;
            "Grammarly" = 1462114288;
            "Mindnode" = 1289197285;
          };
        }
      ]
  );
}
