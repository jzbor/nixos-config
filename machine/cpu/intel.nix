# source: https://github.com/NixOS/nixos-hardware/blob/master/common/cpu/intel/default.nix

{ config, lib, pkgs, ... }:

{
  hardware.cpu.intel.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
}
