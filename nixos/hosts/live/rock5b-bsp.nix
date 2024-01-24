{ pkgs, inputs, lib, ... }:

let
  linuxPackages-rock5b = pkgs.linuxPackagesFor inputs.rock5b.packages.aarch64-linux.linux-rock5b;
in {
  boot.kernelPackages = lib.mkForce linuxPackages-rock5b;
}
