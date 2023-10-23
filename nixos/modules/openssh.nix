{lib, ...}: {
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = lib.mkDefault "no";
  };
}
# use 1pass for ssh keys
#Host *
#	IdentityAgent ~/.1password/agent.sock

