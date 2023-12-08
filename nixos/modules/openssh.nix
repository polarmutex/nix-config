{lib, ...}: {
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = lib.mkDefault "no";
  };
  programs.ssh = {
    startAgent = true;
  };
}
# use 1pass for ssh keys
#Host *
#	IdentityAgent ~/.1password/agent.sock
