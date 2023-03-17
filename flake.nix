{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    jzbor-overlay.url = "github:jzbor/nix-overlay";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };


  outputs = { self, nixpkgs, jzbor-overlay, nixos-hardware }@inputs:
    let
      pkgs-x86_64 = (import nixpkgs {
          system = "x86_64-linux";
          config.allowUnfree = true;
        }).extend jzbor-overlay.overlay;
    in {
      nixosConfigurations.x1-carbon = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        pkgs = pkgs-x86_64;

        modules = [
          ./configuration.nix
          ./machine/x1-carbon

          nixos-hardware.nixosModules.lenovo-thinkpad-x1-6th-gen
          { services.throttled.enable = false; }
        ];

        specialArgs = { inherit inputs; };
    };
  };
}
