{ pkgs, ... }: {
  users.users.polar = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "docker"
    ];
    openssh.authorizedKeys.keys = [
    ];
  };
}
