{ pkgs, ... }: {
  services.xserver = {
    enable = true;
    updateDbusEnvironment = true;
    libinput = {
      enable = true;
      mouse.naturalScrolling = true;
    };
    displayManager.lightdm.enable = true;
    windowManager.leftwm = {
      enable = true;
    };
    windowManager.awesome = {
      enable = true;
      package = pkgs.awesome-git;
      luaModules = [
        #pkgs.awesome-battery-widget-git
        #pkgs.bling-git
        #pkgs.rubato-git
      ];
    };
  };
  environment.systemPackages = with pkgs; [
    alacritty
    dmenu
    eww
  ];
}
