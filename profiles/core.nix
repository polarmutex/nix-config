{ self, config, lib, pkgs, ... }:
let inherit (lib) fileContents;
in
{
  imports = [ ];

  nix.systemFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];

  environment = {

    systemPackages = with pkgs; [
      binutils
      coreutils
      curl
      direnv
      dnsutils
      fd
      git
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

    shellAliases =
      let ifSudo = lib.mkIf config.security.sudo.enable;
      in
      {
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
        nrb = ifSudo "sudo nixos-rebuild";

        # sudo
        s = ifSudo "sudo -E ";
        si = ifSudo "sudo -i";
        se = ifSudo "sudoedit";

        # systemd
        ctl = "systemctl";
        stl = ifSudo "s systemctl";
        utl = "systemctl --user";
        ut = "systemctl --user start";
        un = "systemctl --user stop";
        up = ifSudo "s systemctl start";
        dn = ifSudo "s systemctl stop";
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

  security = {
    protectKernelImage = lib.mkDefault true;
    sudo.extraConfig = ''
      Defaults timestamp_type=global,timestamp_timeout=600
    '';
  };

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
