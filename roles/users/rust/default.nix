{ pkgs, config, lib, ... }:
{

  home.packages = with pkgs; [
    rustup
    rust-analyzer
  ];
}
