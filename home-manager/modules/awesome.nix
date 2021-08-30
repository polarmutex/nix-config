{ config, pkgs, lib, ... }:
let
    utils = import ./utils.nix { config = config; };
in
{
    xsession.scriptPath = ".hm-xsession";
    xsession.enable = true;
    xsession.initExtra = ''
    '';

    xsession.windowManager.awesome = {
        enable = true;
	package = pkgs.awesome;
    };

    xdg.configFile = utils.link-one "config" "." "awesome";
}
