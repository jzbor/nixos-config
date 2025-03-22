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

    nativeBuildInputs = with pkgs.pkgsStatic; [
      clang
      pkg-config
    ];

    cargoLock.lockFile = src + /Cargo.lock;
  };

  inherit (pkgs.pkgsStatic) tealdeer fd;
}
