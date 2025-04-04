{
  config,
  pkgs,
  inputs,
  ...
}: {
  # Load nvidia driver for Xorg and Wayland
  # services.xserver.videoDrivers = ["nvidia"];

  hardware = {
    # nvidia = {
    #   # Modesetting is required.
    #   modesetting.enable = true;
    #   # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    #   powerManagement.enable = false;
    #   # Fine-grained power management. Turns off GPU when not in use.
    #   # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    #   powerManagement.finegrained = false;
    #   # Use the NVidia open source kernel module (not to be confused with the
    #   # independent third-party "nouveau" open source driver).
    #   # Support is limited to the Turing and later architectures. Full list of
    #   # supported GPUs is at:
    #   # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    #   # Only available from driver 515.43.04+
    #   # Do not disable this unless your GPU is unsupported or if you have a good reason to.
    #   open = false;
    #   # Enable the Nvidia settings menu,
    #   # accessible via `nvidia-settings`.
    #   nvidiaSettings = true;
    #   # Optionally, you may need to select the appropriate driver version for your specific GPU.
    #   package = config.boot.kernelPackages.nvidiaPackages.stable;
    #
    #   prime = {
    #     sync.enable = true;
    #     # Make sure to use the correct Bus ID values for your system!
    #     intelBusId = "PCI:0:2:0";
    #     nvidiaBusId = "PCI:1:0:0";
    #   };
    # };
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [nvidia-vaapi-driver];
    };
  };

  environment = {
    variables = {
      # wayland
      # LIBVA_DRIVER_NAME = "nvidia";
      # XDG_SESSION_TYPE = "wayland";
      # GBM_BACKEND = "nvidia-drm";
      # __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      # __GL_GSYNC_ALLOWED = "1";
      # __GL_VRR_ALLOWED = "0"; # Controls if Adaptive Sync should be used. Recommended to set as “0” to avoid having problems on some games.
      # QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      # QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      # CUDA_CACHE_PATH = "$XDG_CACHE_HOME/nv";
    };
    sessionVariables = {
      # wayland
      # NIXOS_OZONE_WL = "1"; # Hint electron apps to use wayland
      # WLR_NO_HARDWARE_CURSORS = "1"; # Fix cursor rendering issue on wlr nvidia.
      # DEFAULT_BROWSER = "${pkgs.firefox}/bin/firefox"; # Set default browser
    };
  };

  #virtualisation.docker.enableNvidia = true;
  #virtualisation.podman.enableNvidia = true;
}
