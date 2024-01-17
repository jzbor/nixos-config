{ pkgs, lib, config, ... }:

with lib;
let
  cfg = config.programs.thunderbird;
in mkIf cfg.enable {
  programs.thunderbird.profiles.default = {
    isDefault = true;
    settings = {};
  };
}
