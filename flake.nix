{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    jzbor-overlay.url = "github:jzbor/nix-overlay";
  };


  outputs = { self, nixpkgs, jzbor-overlay }:
    let
      system = "x86_64-linux";
      pkgs = (import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        }).extend jzbor-overlay.overlay;
    in {
      nixosConfigurations.x1-carbon = nixpkgs.lib.nixosSystem {
        inherit system;
        inherit pkgs;

        modules = [
          ./configuration.nix
          ./machine/x1-carbon
        ];
    };
  };
}
