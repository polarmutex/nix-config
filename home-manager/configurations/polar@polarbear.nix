{self, ...}: {
  lib,
  pkgs,
  ...
}: {
  nixpkgs.allowedUnfree = [];
  activeProfiles = [];
  profiles.base.enable = true;
  #profiles.fonts.enable = true;
  #xsession.enable = lib.mkForce false;
  #xsession.windowManager.awesome.enable = lib.mkForce false;
}
