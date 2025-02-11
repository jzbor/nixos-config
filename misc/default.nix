inputs:

{
  nixOnDroidConfigurations.default = {
    pkgs = import inputs.nixpkgs {
      overlays = [ inputs.parcels.overlays.default ];
      system = "aarch64-linux";
    };
    modules = [ ./nix-on-droid ];
    extraSpecialArgs = { inherit inputs; };
  };
} // (inputs.cf.lib.flakeForDefaultSystems (system: {
  legacyPackages.homeConfigurations."jzbor" = inputs.self.legacyPackages.${system}.homeConfigurations."jzbor@any";
}))
