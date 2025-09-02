{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation {
  pname = "mpv-reload";
  version = "unstable-2023-03-13";

  src = fetchFromGitHub {
    owner = "4e6";
    repo = "mpv-reload";
    rev = "c1219b6ac3ee3de887e6a36ae41a8e478835ae92";
    sha256 = "sha256-+DoKPIulQA3VSeXo8DjoxnPwDfcuCO5YHpXmB+M7EWk=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -D -t $out/share/mpv/scripts reload.lua
    runHook postInstall
  '';

  passthru.scriptName = "reload.lua";

  meta = with lib; {
    description = "mpv plugin for automatic reloading of slow/stuck video streams";
    homepage = "https://github.com/4e6/mpv-reload";
    platforms = platforms.all;
  };
}
