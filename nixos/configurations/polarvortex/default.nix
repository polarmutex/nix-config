{...}: {
  imports = [
    ./configuration.nix
  ];
  profiles = {
    caches.enable = true;
    core.enable = true;
    doas.enable = true;
    nix.enable = true;
    openssh.enable = true;
  };

  users = {
    server.enable = true;
  };
}
