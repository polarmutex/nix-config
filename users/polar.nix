{ config, pkgs, lib, ... }: {

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {

    # Shell is set to zsh for all users as default.
    defaultUserShell = pkgs.zsh;

    users.polar = {
      isNormalUser = true;
      home = "/home/polar";
      description = "";
      extraGroups =
        [ "docker" "wheel" "networkmanager" "audio" "libvirtd" ];
      shell = pkgs.zsh;

      # Public ssh-keys that are authorized for the user. Fetched from github
      openssh.authorizedKeys.keyFiles = [
        (
          builtins.fetchurl {
            url = "https://github.com/polarmutex.keys";
            sha256 =
              "sha256:0a7qny3c88iy73sdn2l5v5887m3mp9vxg0gd9xi182pkdvg4zpjs";
          }
        )
      ];
    };
  };

  # Allow to run nix
  nix.allowedUsers = [ "polar" ];
}
