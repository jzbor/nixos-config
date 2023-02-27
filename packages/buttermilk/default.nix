{ lib, stdenv, fetchFromGitHub, pkgs, ... }:

stdenv.mkDerivation rec {
  pname = "buttermilk";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "jzbor";
    repo = pname;
    rev = version;
    sha256 = "sha256-quxeFBrRzaLDc5w7FcxEKR8xFH+vCweT0nph+9bn3P8=";
  };

  meta = with lib; {
    description = "My basic personal terminal emulator based on VTE";
    homepage = "https://github.com/jzbor/buttermilk";
    license = licenses.mit;
    maintainers = [ maintainers.jzbor ];
  };

  nativeBuildInputs = with pkgs; [
    pkg-config
  ];

  buildInputs = with pkgs; [
    inih
    vte
  ];

  installPhase = ''
    make PREFIX=/ DESTDIR="$out" install
  '';
}
