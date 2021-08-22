# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./users.nix
      ./firewall.nix
      ./webserver.nix
    ];

  nixpkgs.config = {
    packageOverrides = pkgs: {
      #    unstable = import <nixos-unstable> {
      #      config = config.nixpkgs.config;
      #    };
      my = import ./pkgs { inherit pkgs; };
    };
  };

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/vda"; # or "nodev" for efi only

  networking.hostName = "brianryall-xyz"; # Define your hostname.

  # Set your time zone.
  time.timeZone = "America/New_York";
  services.ntp.enable = true;

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp1s0.useDHCP = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
    htop
    mosh
    caddy
    my.fathom
  ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
  };

  # Fathom analytics
  systemd.services.fathom = {
    description = "Fathom Server";
    requires = [ "network.target" ];
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "simple";
      User = "brian";
      Restart = "on-failure";
      RestartSec = 3;
      WorkingDirectory = "/home/brian/my-fathom-site";
      ExecStart = "${pkgs.my.fathom}/bin/fathom --config=/etc/fathom.env server";
    };
  };
  environment.etc = {
    "fathom.env".source = .secret/fathom.env;
  };
  # Gitea
  users.users.git = {
    description = "Gitea Service";
    home = config.services.gitea.stateDir;
    useDefaultShell = true;
    group = "git";
    isSystemUser = true;
  };
  users.groups.git = {};

  services.gitea = {
    enable = true;
    user = "git";
    domain = "localhost";
    rootUrl = "https://localhost/";
    httpAddress = "127.0.0.1";
    httpPort = 49381;
    log.level = "Error";
    settings = {
      server.SSH_DOMAIN = "localhost";
      other.SHOW_FOOTER_VERSION = true;
    };
    dump.enable = false;
    database.user = "git";
  };

  # miniflux
  ervices.miniflux = {
    enable = true;
    adminCredentialsFile = ./.secrets/miniflux-admin-credentials;
    config = {
      LISTEN_ADDR = "127.0.0.1:8080";
      BASE_URL = "https://reader.${domain}/";

      CLEANUP_ARCHIVE_UNREAD_DAYS = "-1";
      CLEANUP_ARCHIVE_READ_DAYS = "-1";
    };
  };


  # Let trusted users upload unsigned packages
  nix.trustedUsers = [ "@wheel" ];
  # Clean up packages after a while
  nix.gc = {
    automatic = true;
    dates = "weekly UTC";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?

}
