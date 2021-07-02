#!/bin/sh
pushd ~/repos/nix-dotfiles
sudo nixos-rebuild switch --flake .#
popd
