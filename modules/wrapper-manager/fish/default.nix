{
  lib,
  pkgs,
  ...
}: let
  inherit (pkgs) writeTextDir;
  vendorConf = "share/fish/vendor_conf.d";

  direnvConfig = writeTextDir "direnvrc" ''
    source ${pkgs.nix-direnv}/share/nix-direnv/direnvrc
  '';

  config =
    writeTextDir "${vendorConf}/polar_config.fish"
    # fish
    ''
      # NixOS's /etc/profile already exits early with __ETC_PROFILE_SOURCED
      # For some reason, status is-login doesn't work consistently
      # fenv source /etc/profile

      if status is-interactive
        # set -gx STARSHIP_CONFIG {../../../misc/starship.toml}
        ${lib.getExe pkgs.carapace} _carapace fish | source
        function starship_transient_prompt_func
          ${lib.getExe pkgs.starship} module character
        end
        ${lib.getExe pkgs.starship} init fish | source
        enable_transience
        set -gx DIRENV_LOG_FORMAT ""
        set -gx direnv_config_dir ${direnvConfig}
        ${lib.getExe pkgs.direnv} hook fish | source
      end
    '';
in {
  wrappers.fish = {
    basePackage = pkgs.fish;
    extraWrapperFlags = ''
      --prefix XDG_DATA_DIRS : "${
        lib.makeSearchPathOutput "out" "share" [
          # order matters
          # loadPlugin
          config
        ]
      }"
    '';
  };
}
