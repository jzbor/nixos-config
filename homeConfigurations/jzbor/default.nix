{ inputs, pkgs, ... }@args:

inputs.home-manager.lib.homeManagerConfiguration {
  inherit pkgs;
  modules = [ ./home-configuration.nix ];
  extraSpecialArgs = args;
}

