{ inputs, pkgs, ... }@args:


let
  mkHome = cfg: inputs.home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    modules = [ cfg ];
    extraSpecialArgs = args;
  };
in {
  jzbor = mkHome ../../homeConfigurations/jzbor/home-configuration.nix;
  "jzbor@pinebook-pro" = mkHome (../../homeConfigurations + "/jzbor@pinebook-pro/home-configuration.nix");
  "jzbor@pinenote" = mkHome (../../homeConfigurations + "/jzbor@pinenote/home-configuration.nix");
}
