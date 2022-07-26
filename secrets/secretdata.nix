{ lib, ... }:

lib.mapAttrs'
  (name: _: (lib.nameValuePair name {
    sopsFile = ./encrypted + "/${name}";
    format = "binary";
  }))
  (builtins.readDir ./encrypted)
