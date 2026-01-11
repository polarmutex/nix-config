{
  lib,
  modulesPath,
  ...
}: let
  moduli_file = "ssh_moduli";
in {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot = {
    initrd.availableKernelModules = [
      # "virtio_pci" "virtio_scsi" "ahci" "sd_mod"
    ];
    initrd.kernelModules = [];
    kernelModules = [];
    extraModulePackages = [];
    kernelParams = ["net.ifnames=0"];
  };

  networking = {
    usePredictableInterfaceNames = false;
    useDHCP = false;
    interfaces.eth0.useDHCP = true;

    domain = "polarmutex.dev";
  };

  security.acme.acceptTerms = true;
  security.acme.defaults.email = "letsencrypt@brianryall.xyz";

  services = {
    nginx = {
      enable = true;
      recommendedOptimisation = true;
      recommendedTlsSettings = true;
      recommendedProxySettings = true;
      clientMaxBodySize = "128m";

      # Common security configuration for all virtual hosts
      commonHttpConfig = ''
        # Request limits
        client_body_timeout 12;
        client_header_timeout 12;
        send_timeout 10;

        # Rate limiting zone (10MB can track ~160k IPs)
        limit_req_zone $binary_remote_addr zone=general:10m rate=10r/s;
      '';

      virtualHosts = {};
    };
  };

  # Block anything that is not HTTP(s) or SSH.
  # need ssh to be open for git server
  # need port 80 open for letsencrypt
  # need port 443 open for secure webpages
  networking.firewall = {
    enable = true;
    allowPing = true;
    allowedTCPPorts = [80 443 22];

    # Rate limiting to prevent DoS and brute-force attacks
    extraCommands = ''
      # SSH rate limiting: max 5 new connections per minute per IP
      iptables -A INPUT -p tcp --dport 22 -m state --state NEW -m recent --set --name SSH
      iptables -A INPUT -p tcp --dport 22 -m state --state NEW -m recent --update --seconds 60 --hitcount 5 --rttl --name SSH -j DROP

      # HTTP rate limiting: max 100 new connections per minute per IP
      iptables -A INPUT -p tcp --dport 80 -m state --state NEW -m recent --set --name HTTP
      iptables -A INPUT -p tcp --dport 80 -m state --state NEW -m recent --update --seconds 60 --hitcount 100 --rttl --name HTTP -j DROP

      # HTTPS rate limiting: max 100 new connections per minute per IP
      iptables -A INPUT -p tcp --dport 443 -m state --state NEW -m recent --set --name HTTPS
      iptables -A INPUT -p tcp --dport 443 -m state --state NEW -m recent --update --seconds 60 --hitcount 100 --rttl --name HTTPS -j DROP
    '';

    # Cleanup rules on firewall stop
    extraStopCommands = ''
      iptables -D INPUT -p tcp --dport 22 -m state --state NEW -m recent --set --name SSH 2>/dev/null || true
      iptables -D INPUT -p tcp --dport 22 -m state --state NEW -m recent --update --seconds 60 --hitcount 5 --rttl --name SSH -j DROP 2>/dev/null || true
      iptables -D INPUT -p tcp --dport 80 -m state --state NEW -m recent --set --name HTTP 2>/dev/null || true
      iptables -D INPUT -p tcp --dport 80 -m state --state NEW -m recent --update --seconds 60 --hitcount 100 --rttl --name HTTP -j DROP 2>/dev/null || true
      iptables -D INPUT -p tcp --dport 443 -m state --state NEW -m recent --set --name HTTPS 2>/dev/null || true
      iptables -D INPUT -p tcp --dport 443 -m state --state NEW -m recent --update --seconds 60 --hitcount 100 --rttl --name HTTPS -j DROP 2>/dev/null || true
    '';
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

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
}
