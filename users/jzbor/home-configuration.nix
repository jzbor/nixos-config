{ flake, ... }:

{
  home.stateVersion = "22.11";

  imports = [ flake.homeModules.default ];
}
