{ config, lib, pkgs, ... }:
{
  imports = [
    ./nix.nix
    ./openssh.nix
    ./zsh.nix
  ];

  #boot.kernelParams = [ "log_buf_len=10M" ];

  time.timeZone = "US/Eastern";
  i18n.defaultLocale = "en_US.UTF-8";

  environment = {
    systemPackages = with pkgs; [
      coreutils
      gitAndTools.gitFull
      gptfdisk
      gnumake
      rsync
      wget
    ];
  };

  networking = {
    useDHCP = lib.mkDefault true;
    #useNetworkd = true;
  };

  nix.settings.trusted-users = [ "root" "@wheel" ];

  security = {
    #protectKernelImage = lib.mkDefault true;
    sudo.enable = false;
    doas = {
      enable = true;
      wheelNeedsPassword = false;
      extraRules = [
        {
          groups = [ "wheel" ];
          persist = true;
        }
        {
          users = [ "polar" ];
          noPass = true;
          runAs = "root";
        }
      ];
    };
    wrappers.sudo = {
      setuid = true;
      owner = "root";
      group = "root";
      source = "${pkgs.doas}/bin/doas";
    };
  };

  users.mutableUsers = false;
}
