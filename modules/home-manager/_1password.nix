_: let
  onePassPath = "~/.1password/agent.sock";
in {
  programs.ssh = {
    extraConfig = ''
      Host *
          IdentityAgent ${onePassPath}
    '';
  };
  programs.git = {
    enable = true;
    extraConfig = {
      gpg = {
        format = "ssh";
      };
      "gpg \"ssh\"" = {
        program = "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
      };
      commit = {
        gpgsign = true;
      };

      user = {
        signingKey = "...";
      };
    };
  };
}
