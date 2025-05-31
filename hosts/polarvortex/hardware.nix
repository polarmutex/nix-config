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

    domain = "brianryall.xyz";
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
