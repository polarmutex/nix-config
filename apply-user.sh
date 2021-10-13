#!/bin/sh
nix build .#homeManagerConfigurations.polar.activationPackage
./result/activate
