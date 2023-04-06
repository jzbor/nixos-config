{ config, lib, ... }:

{
  imports = [
    # Include common configuration files
    ../common

    # Used programs
    ../../programs/coding.nix
    ../../programs/multimedia.nix
    ../../programs/office.nix
  ];
}
