{pkgs, ...}: {
  virtualisation = {
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
    containers.storage.settings = {
      storage = {
        driver = "zfs";

        graphroot = "/var/lib/containers/storage";

        runroot = "/run/containers/storage";
      };
    };
  };
  environment = {
    systemPackages = with pkgs; [
      podman-compose
    ];
  };
}
