# Configuration for polarvortex
{
  pkgs,
  options,
  ...
}: let
  moduli_file = "ssh_moduli";
in {
  imports = [
    ./hardware-configuration.nix
    ./services/blog.nix
    ./services/gitea.nix
    #./services/miniflux.nix
    ./services/umami.nix
  ];

  lollypops.deployment = {
    # Where on the remote the configuration (system flake) is placed
    config-dir = "/var/src/lollypops";

    # SSH connection parameters
    ssh.host = "brianryall.xyz";
    ssh.user = "polar";
    ssh.command = "ssh";

    # sudo options
    sudo.enable = true;
    sudo.command = "sudo";
  };

  system.stateVersion = "22.05";

  #sops.defaultSopsFile = ./secrets.yaml;

  users.users.root.initialHashedPassword = "$6$XvQOK8GW5DiRzqhR$g2LCu4rz2OfHRmYUbzaxTn/hz0h8IEHREG3/oW6U/8N3miFxUoYhIiLNjoS0cZXQHqgcaVAv5y1t4.eKxZi/..";

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
    allowedTCPPorts = [80 443 22];
  };

  #services.tailscale.enable = true;

  # Tell the firewall to implicitly trust packets routed over Tailscale:
  #networking.firewall.trustedInterfaces = [ "tailscale0" ];

  # TODO look into and limit space
  #security.auditd.enable = true;
  #security.audit.enable = true;
  #security.audit.rules = [ "-a exit,always -F arch=b64 -S execve" ];

  # remove onec fips req goes away
  #services.openssh.kexAlgorithms =
  #  options.services.openssh.kexAlgorithms.default
  #  ++ [
  #  ];
  #services.openssh.macs =
  #  options.services.openssh.macs.default
  #  ++ [
  # ];
  services.openssh.moduliFile = "/etc/${moduli_file}";
  environment.etc."${moduli_file}".text = "";

  services.nginx = {
    enable = true;
    recommendedOptimisation = true;
    recommendedTlsSettings = true;
    recommendedProxySettings = true;
    clientMaxBodySize = "128m";

    virtualHosts = {};
  };

  services.logrotate = {
    enable = true;
    settings = {
      journal = {
        files = ["/var/log/journal"];
        frequency = "daily";
        rotate = 10;
      };
      nginx = {
        files = ["/var/log/nginx/*.log"];
        frequency = "daily";
        rotate = 10;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    #tailscale
    unzip
  ];
}
