# Configuration for polarvortex
{ pkgs, ... }: {

  imports = [
    ./hardware-configuration.nix
    ../modules/core
    ./services/blog.nix
    ./services/gitea.nix
    ./services/miniflux.nix
    ./services/umami.nix
  ];

  system.stateVersion = "22.05";

  sops.defaultSopsFile = ./secrets.yaml;

  users.users.root.initialHashedPassword = "$6$XvQOK8GW5DiRzqhR$g2LCu4rz2OfHRmYUbzaxTn/hz0h8IEHREG3/oW6U/8N3miFxUoYhIiLNjoS0cZXQHqgcaVAv5y1t4.eKxZi/..";
  users.users.polar = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    initialHashedPassword = "$6$p/7P2dlx4xBEV72W$Ooep2JnmTJhTnexObNtAt3CNqRIhqgA2cD4bZtWMXOYAP.yBig8XToII0Fxy2Kc/Q12gep7Uqfsq6wIxRv7f21";
    shell = pkgs.fish;
  };

  nix.settings.auto-optimise-store = true;

  networking.usePredictableInterfaceNames = false;
  networking.useDHCP = false;
  networking.interfaces.eth0.useDHCP = true;
  networking.domain = "brianryall.xyz";

  security.acme.acceptTerms = true;
  security.acme.defaults.email = "letsencrypt@brianryall.xyz";

  # Block anything that is not HTTP(s) or SSH.
  # need ssh to be open for git server
  # need port 80 open for letsencrypt
  # need port 443 open for secure webpages
  networking.firewall = {
    enable = true;
    allowPing = true;
    allowedTCPPorts = [ 80 443 22 ];
  };

  #services.tailscale.enable = true;

  # Tell the firewall to implicitly trust packets routed over Tailscale:
  #networking.firewall.trustedInterfaces = [ "tailscale0" ];

  # TODO look into and limit space
  #security.auditd.enable = true;
  #security.audit.enable = true;
  #security.audit.rules = [ "-a exit,always -F arch=b64 -S execve" ];

  services.nginx = {
    enable = true;
    recommendedOptimisation = true;
    recommendedTlsSettings = true;
    recommendedProxySettings = true;
    clientMaxBodySize = "128m";

    virtualHosts = { };
  };

  environment.systemPackages = with pkgs; [
    #tailscale
    unzip
  ];

}
