{
  flake.nixosModules.docker = {
    config,
    pkgs,
    lib,
    ...
  }: {
    environment = {
      systemPackages = with pkgs; [
        docker-compose
      ];
    };

    virtualisation.docker = {
      enable = true;
      enableOnBoot = true;
      # extraOptions =
      extraOptions = lib.concatStringsSep " " [
        "--registry-mirror=https://mirror.gcr.io"
        # "--add-runtime crun=${pkgs.crun}/bin/crun"
        # "--default-runtime=crun"
        # "--iptables=false"
        # "--ip6tables=false"
      ];
      autoPrune = {
        enable = true;
        flags = [
          "all"
          "force"
        ];
      };
    };
    # hardware.nvidia-container-toolkit.enable =
    #   lib.mkIf (builtins.any (v: v == "nvidia") config.services.xserver.videoDrivers) true;

    virtualisation.oci-containers = {
      backend = "docker";
    };

    users.groups.docker.members = config.users.groups.wheel.members;
  };
}
