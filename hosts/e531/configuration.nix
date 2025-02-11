{ flake, ... }:

{
  imports = [ flake.nixosModules.default ];

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "24.05";
  networking.hostName = "e531";
  jzbor-system.boot.scheme = "traditional";
}
