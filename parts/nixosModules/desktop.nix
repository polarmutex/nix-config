{
  flake.nixosModules.desktop = {
    pkgs,
    lib,
    ...
  }: {
    # Common server packages
    environment = {
    };

    time.timeZone = lib.mkDefault "US/Eastern";

    # No mutable users by default
    users.mutableUsers = false;

    # Define default system version
    system.stateVersion = "23.05";
  };
}
