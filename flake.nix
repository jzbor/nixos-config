{
  outputs = { self, nixpkgs }: {
    nixosConfigurations.x1-carbon = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./configuration.nix ];
    };
  };
}
