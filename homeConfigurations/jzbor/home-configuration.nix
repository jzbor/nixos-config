{ self, ... }:

{
  home.stateVersion = "22.11";

  imports = [ self.homeModules.default ];
}
