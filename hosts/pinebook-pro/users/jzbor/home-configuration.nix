{ flake, perSystem, ... }:

let
  pkgs = perSystem.nixpkgs;
  inherit (pkgs) lib;
in {
  imports = [ flake.homeModules.default ];

  services.picom.enable = lib.mkForce false;
  services.nextcloud-client.enable =pkgs.lib.mkForce false;
}
