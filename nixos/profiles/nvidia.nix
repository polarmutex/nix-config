{...}: {
  boot.blacklistedKernelModules = ["nouveau"];

  services.xserver.videoDrivers = ["nvidia"];

  #virtualisation.docker.enableNvidia = true;
  #virtualisation.podman.enableNvidia = true;
}
