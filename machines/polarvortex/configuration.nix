# Configuration for polarvortex
{ self, pkgs, ... }: {

  imports = [ ./hardware-configuration.nix ];

  polar.server = {
    enable = true;
    hostname = "polarvortex";
  };

  polar.services = {
    miniflux.enable = true;
    gitea.enable = true;
    ssmtp.enable = true;
    blog.enable = true;
    fathom.enable = true;
    rss-bridge.enable = true;
    vikunja.enable = true;
  };

  nix.autoOptimiseStore = true;

  networking.usePredictableInterfaceNames = false;
  networking.useDHCP = false;
  networking.interfaces.eth0.useDHCP = true;
  networking.domain = "brianryall.xyz";

  security.acme.acceptTerms = true;
  security.acme.email = "brian+letsencrypt@brianryall.xyz";

  # Block anything that is not HTTP(s) or SSH.
  # need ssh to be open for git server
  # need port 80 open for letsencrypt
  # need port 443 open for secure webpages
  networking.firewall = {
    enable = true;
    allowPing = true;
    allowedTCPPorts = [ 80 443 22 ];
  };

  services.tailscale.enable = true;

  # Tell the firewall to implicitly trust packets routed over Tailscale:
  networking.firewall.trustedInterfaces = [ "tailscale0" ];

  security.auditd.enable = true;
  security.audit.enable = true;
  security.audit.rules = [ "-a exit,always -F arch=b64 -S execve" ];

  services.nginx = {
    enable = true;
    recommendedOptimisation = true;
    recommendedTlsSettings = true;
    recommendedProxySettings = true;
    clientMaxBodySize = "128m";

    virtualHosts = { };
  };

  environment.systemPackages = with pkgs; [ tailscale ];

}
