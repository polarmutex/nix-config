# Configuration for polarvortex
{ self, pkgs, ... }: {

  imports = [ ./hardware-configuration.nix ];

  polar.server = {
    enable = true;
    hostname = "polarvortex";
    homeConfig = {
      imports = [
        ../../home-manager/home-server.nix
        {
          nixpkgs.overlays = [
            self.overlay
            self.inputs.neovim-flake.overlay
          ];
        }
      ];
    };
  };

  polar.services = {};

  nix.autoOptimiseStore = true;

  networking.usePredictableInterfaceNames = false;
  networking.useDHCP = false;
  networking.interfaces.eth0.useDHCP = true;

  security.acme.acceptTerms = true;
  security.acme.email = "brian+letsencrypt@brianryall.xyz";

  # Block anything that is not HTTP(s) or SSH.
  networking.firewall = {
    enable = true;
    allowPing = true;
    allowedTCPPorts = [ 80 443 22 ];
  };

  services.nginx = {
    enable = true;
    recommendedOptimisation = true;
    recommendedTlsSettings = true;
    clientMaxBodySize = "128m";

    virtualHosts = {};
  };

  environment.systemPackages = with pkgs; [
    neovim-nightly
  ];

}
