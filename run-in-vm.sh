#!/bin/sh

rm *.qcow2
nix-build '<nixpkgs/nixos>' -A vm -I nixos-config=./configuration.nix $@ \
	&& ./result/bin/run-*-vm
