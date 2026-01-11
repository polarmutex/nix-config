{
  pkgs,
  lib,
  ...
}: {
  # Common server packages
  environment = {
    systemPackages = with pkgs; [
      bat
      bottom
      curl
      dnsutils
      htop
      jq
      ripgrep
      unzip
    ];

    # List of available shells
    shells = with pkgs; [
      bash
      zsh
      fish
    ];

    # Use helix as the default editor
    variables.EDITOR = "nvim";
  };

  time.timeZone = lib.mkDefault "US/Eastern";

  # Journald log rotation and retention best practices
  services.journald.extraConfig = ''
    # Storage settings
    SystemMaxUse=1G
    SystemKeepFree=2G
    SystemMaxFileSize=100M

    # Runtime (volatile) storage
    RuntimeMaxUse=100M
    RuntimeKeepFree=100M

    # Retention settings
    MaxRetentionSec=2week
    MaxFileSec=1day

    # Forward to syslog for additional processing if needed
    ForwardToSyslog=no

    # Compression
    Compress=yes

    # Rate limiting to prevent log flooding
    RateLimitIntervalSec=30s
    RateLimitBurst=10000
  '';

  # No mutable users by default
  users.mutableUsers = false;

  # Use fish as default shell
  # users.defaultUserShell = pkgs.fish;

  # Define default system version
  system.stateVersion = "23.05";

  # Automated security updates
  system.autoUpgrade = {
    enable = true;
    allowReboot = false; # Set to true if you want automatic reboots for kernel updates
    dates = "weekly"; # Run updates weekly (every Sunday at 00:00)
    flake = "github:polarmutex/nix-config?ref=main"; # Point to your main branch
    # flags = [
    #   "--update-input"
    #   "nixpkgs"
    #   "--commit-lock-file"
    # ];
    # Restart services that have been updated
    operation = "switch";
  };
}
