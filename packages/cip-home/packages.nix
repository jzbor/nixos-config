{ pkgs, ... }:

{
  # marswm = pkgs.pkgsStatic.rustPlatform.buildRustPackage rec {
  #   inherit (perSystem.parcels.marswm) pname version src;

  #   buildInputs = with pkgs.pkgsStatic; [
  #     libx11
  #     libxft
  #     libxinerama
  #     libxrandr
  #   ];

  #   nativeBuildInputs = with pkgs.pkgsStatic; [
  #     clang
  #     pkg-config
  #   ];

  #   cargoLock.lockFile = src + /Cargo.lock;
  # };

  # inherit (pkgs.pkgsStatic) tealdeer fd;

  inherit (pkgs) cascadia-code;
}
