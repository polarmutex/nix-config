{ config, ... }: {
  nix = {
    settings = {
      allowed-users = [ "@wheel" ];
      trusted-users = [ "root" "@wheel" ];
      substituters = [
        "https://nix-config.cachix.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-config.cachix.org-1:Vd6raEuldeIZpttVQfrUbLvXJHzzzkS0pezXCVVjDG4="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
    daemonCPUSchedPolicy = "batch";
    daemonIOSchedPriority = 5;
    distributedBuilds = true;
    optimise = {
      automatic = true;
      dates = [ "03:00" ];
    };
  };
}
