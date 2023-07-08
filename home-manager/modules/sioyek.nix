{pkgs, ...}: let
  inherit (pkgs.stdenv) isLinux;
in {
  programs.sioyek = {
    package = with pkgs;
      if isLinux
      then sioyek
      else runCommand "sioyek-0.0.0" {} "mkdir $out";
    bindings = {
      "move_up" = "k";
      "move_down" = "j";
      "move_left" = "h";
      "move_right" = "l";
      "screen_down" = ["d" "<C-d>"];
      "screen_up" = ["u" "<C-u>"];
      "toggle_dark_mode" = "<C-i>";
    };
  };
  xdg.mimeApps.defaultApplications = {
    "application/pdf" = ["sioyek.desktop"];
    "application/x-pdf" = ["sioyek.desktop"];
    "application/fdf" = ["sioyek.desktop"];
    "application/xdp" = ["sioyek.desktop"];
    "application/xfdf" = ["sioyek.desktop"];
    "application/pdx" = ["sioyek.desktop"];
  };
}
