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
              "sha256:01vg72kgaw8scgmfif1sm9wnzq3iis834gn8axhpwl2czxcfysl9";
          }
        )
      ];
    };
  };

  # Allow to run nix
  nix.allowedUsers = [ "polar" ];
}
