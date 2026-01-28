{
  flake.nixosModules.onepassword = {pkgs, ...}: {
    programs = {
      _1password = {
        enable = true;
        package = pkgs.unstable._1password-cli;
      };
      _1password-gui = {
        enable = true;
        package = pkgs.unstable._1password-gui;
        # Certain features, including CLI integration and system authentication support,
        # require enabling PolKit integration on some desktop environments (e.g. Plasma).
        polkitPolicyOwners = ["polar"];
      };
      # _1password-shell-plugins = {
      #   enable = true;
      #   package = pkgs.unstable._1password-shell-plugins;
      #   plugins = with pkgs; [
      #     unstable.gh # if shell/git
      #     # cachix
      #   ];
      # };
    };
    # Unlocking Browser Extensions
    # environment.etc = {
    #   "1password/custom_allowed_browsers" = {
    #     text = ''
    #       vivaldi-bin
    #     '';
    #     mode = "0755";
    #   };
    # };
  };
}
