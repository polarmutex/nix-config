{
  flake.nixosModules.syncthing = {
    services.syncthing = {
      enable = true;
      user = "polar";
      group = "users";
      dataDir = "/home/polar/.syncthing";
      guiAddress = "127.0.0.1:8384";
      settings.options = {
        urAccepted = -1;
        globalAnnounceEnabled = false;
        localAnnounceEnabled = false;
        relaysEnabled = false;
        natEnabled = false;
      };
    };

    # Both peers are known Tailscale devices reached by static tailnet
    # address, so the only port syncthing needs is the direct-dial transfer
    # port, and only on the tailscale interface.
    networking.firewall.interfaces."tailscale0".allowedTCPPorts = [22000];
  };
}
