{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs }: {
    nixosConfigurations.x1-carbon = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./machine/x1-carbon ];
    };
  };
}
