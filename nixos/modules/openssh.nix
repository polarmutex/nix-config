{lib, ...}: {
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = lib.mkDefault "no";
  };
}
