{ self, config, lib, pkgs, ... }:
let inherit (lib) fileContents;
in
{
  imports = [ ];

  nix.systemFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];

  security = {
    protectKernelImage = lib.mkDefault true;
    # TODO find a way to disable this
    sudo.enable = true;
    doas = {
      enable = true;
      wheelNeedsPassword = false;
      extraRules = [
        {
          users = [ "polar" ];
          noPass = true;
          cmd = "nix-collect-garbage";
          runAs = "root";
        }
      ];
    };
  };

  environment = {

    systemPackages = with pkgs; [
      binutils
      coreutils
      curl
      direnv
      dnsutils
      fd
      git
      git-crypt
      gnumake
      gnupg
      htop
      moreutils
      neovim
      nix-index
      nmap
      ripgrep
      rsync
      wget
      whois
      usbutils
      utillinux
    ];

    shellAliases = {
      # quick cd
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..";

      # git
      g = "git";

      # grep
      grep = "rg";
      gi = "grep -i";

      # nix
      n = "nix";
      np = "n profile";
      ni = "np install";
      nr = "np remove";
      ns = "n search --no-update-lock-file";
      nf = "n flake";
      nepl = "n repl '<nixpkgs>'";
      srch = "ns nixos";
      nrb = "doas nixos-rebuild";

      # sudo
      sudo = "doas";
      s = "doas";

      # systemd
      ctl = "systemctl";
      stl = "s systemctl";
      utl = "systemctl --user";
      ut = "systemctl --user start";
      un = "systemctl --user stop";
      up = "s systemctl start";
      dn = "s systemctl stop";
      jtl = "journalctl";

    };
  };

  fonts = {
    fonts = with pkgs; [ powerline-fonts dejavu_fonts ];

    fontconfig.defaultFonts = {

      monospace = [ "DejaVu Sans Mono for Powerline" ];

      sansSerif = [ "DejaVu Sans" ];

    };
  };

  nix = {

    autoOptimiseStore = true;

    gc = {
      automatic = true;
      dates = "hourly";
      options = "--delete-older-than 7d";
    };

    optimise = {
      automatic = true;
      dates = [ "hourly" ];
    };

    useSandbox = true;
    allowedUsers = [ "@wheel" ];
    trustedUsers = [ "root" "@wheel" ];
    daemonCPUSchedPolicy = lib.mkDefault "idle";
    daemonIOSchedPriority = lib.mkDefault 7;

    extraOptions = "experimental-features = nix-command flakes";
    package = pkgs.nixFlakes;

  };

  # For rage encryption, all hosts need a ssh key pair
  services.openssh = {
    enable = true;
    openFirewall = lib.mkDefault true;
    permitRootLogin = "yes";
    passwordAuthentication = true;
  };

  services.earlyoom.enable = true;

  #sops = {
  #  defaultSopsFile = ../secrets/secrets.yaml;
  #};

  #
  # Locales
  #

  i18n = {
    defaultLocale = lib.mkDefault "en_US.UTF-8";
  };

  time.timeZone = lib.mkDefault "America/New_York";

  services.journald.extraConfig = lib.mkDefault ''
    SystemMaxUse=250M
    SystemMaxFileSize=50M
  '';

}
