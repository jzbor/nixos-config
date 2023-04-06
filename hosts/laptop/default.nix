{ config, lib, ... }:

{
  imports = [
    # Include common configuration files
    ../common

    ../../modules/desktop

    # Used programs
    ../../modules/collections/coding.nix
    ../../modules/collections/multimedia.nix
    ../../modules/collections/office.nix
  ];
}
