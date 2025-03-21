{ pkgs, perSystem, ... }:

{
  marswm = pkgs.pkgsStatic.rustPlatform.buildRustPackage rec {
    inherit (perSystem.parcels.marswm) pname version src;

    buildInputs = with pkgs.pkgsStatic; [
      xorg.libX11
      xorg.libXft
      xorg.libXinerama
      xorg.libXrandr
    ];

    nativeBuildInputs = with pkgs; [
      clang
      pkg-config
    ];

    cargoLock.lockFile = src + /Cargo.lock;
  };
}
