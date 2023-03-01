{ lib, rustPlatform, fetchFromGitHub, pkgs, ... }:

rustPlatform.buildRustPackage rec {
  pname = "marswm";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "jzbor";
    repo = pname;
    rev = version;
    sha256 = "sha256-IjiNBBXUfrostJcOG6QhqqvQYNN7l+JOERRuA4/MWvk=";
  };

  cargoLock = {
    lockFile = "${src}/Cargo.lock";
  };

  nativeBuildInputs = with pkgs; [
    pkg-config
  ];

  buildInputs = with pkgs; [
    xorg.libX11
    xorg.libXft
    xorg.libXinerama
    xorg.libXrandr
  ];

  meta = with lib; {
    description = "A modern window manager featuring dynamic tiling (rusty successor to moonwm).";
    homepage = "https://github.com/jzbor/marswm";
    license = licenses.mit;
    maintainers = [ maintainers.jzbor ];
  };
}
