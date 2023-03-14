{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  inputs.jzbor_overlay.url = "github:jzbor/nix-overlay";

  outputs = { self, nixpkgs, jzbor_overlay }: {
    nixosConfigurations.x1-carbon = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
	({ pkgs, ... }: { nixpkgs.overlays = [ jzbor_overlay.overlay ]; })
	./common.nix
        ./machine/x1-carbon
      ];
    };
  };
}
