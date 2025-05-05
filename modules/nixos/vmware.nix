{pkgs, ...}: {
  virtualisation.vmware.host = {
    enable = true;
    package = pkgs.unstable.vmware-workstation;
  };
}
