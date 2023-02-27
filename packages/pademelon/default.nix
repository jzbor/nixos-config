{ lib, stdenv, fetchFromGitHub, pkgs, wrapGAppsHook, python3, ... }:

stdenv.mkDerivation rec {
  pname = "pademelon";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "jzbor";
    repo = pname;
    rev = version;
    sha256 = "sha256-RuWoNrvGisF3I+gUQF5+2A1sW5dmgyTK0nwqcZJjqyY=";
  };

  meta = with lib; {
    description = "A desktop manager for modular Linux desktop setups.";
    homepage = "https://github.com/jzbor/pademelon";
    license = licenses.mit;
    maintainers = [ maintainers.jzbor ];
  };

  nativeBuildInputs = with pkgs; [
    gobject-introspection
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = with pkgs; [
    glib
    go-md2man
    gtk3
    imlib2
    inih
    libcanberra
    power-profiles-daemon
    python3
    xorg.libX11
    xorg.libXi
    xorg.libXrandr
    libappindicator
  ];

  strictDeps = false;

  propagateBuildInputs = with pkgs; [
    python3Packages.pygobject3
    python3Packages.gst-python
  ];

  preFixup = ''
    gappsWrapperArgs+=(
    --prefix PYTHONPATH : "${python3.withPackages (pp: [ pp.pygobject3 ])}/${python3.sitePackages}"
    )
  '';

  installPhase = ''
    make PREFIX=/ DESTDIR="$out" install-all
  '';
}
