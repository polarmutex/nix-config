#!/bin/sh
pushd ~/repos/nix-dotfiles
nix build .#homeManagerConfigurations.polar.activationPackage
./result/activate
popd
