#!/bin/sh
pushd ~/repos/nix-dotfiles
home-manager switch -f ./home-manager/home.nix
popd
