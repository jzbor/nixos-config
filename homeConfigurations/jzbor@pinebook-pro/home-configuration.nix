{ self, pkgs, ... }:

with pkgs.lib;
{
  imports = [ self.homeModules.default ];

  services.picom.enable = mkForce false;
  services.nextcloud-client.enable = mkForce false;
}
