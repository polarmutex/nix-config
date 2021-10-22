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
  };

  nix.autoOptimiseStore = true;

  networking.usePredictableInterfaceNames = false;
  networking.useDHCP = false;
  networking.interfaces.eth0.useDHCP = true;
  networking.domain = "brianryall.xyz";

  security.acme.acceptTerms = true;
  security.acme.email = "brian+letsencrypt@brianryall.xyz";

  # Block anything that is not HTTP(s) or SSH.
  networking.firewall = {
    enable = true;
    allowPing = true;
    allowedTCPPorts = [ 443 ];
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
