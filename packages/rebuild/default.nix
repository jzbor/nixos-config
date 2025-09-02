{ self, pkgs, ...}: pkgs.writeShellApplication {
  name = "rebuild";
  text = ''
      if test -e /run/current-system/activate; then
        nix run ${self}#rebuild-system
      fi
      nix run ${self}#rebuild-home
      nix run ${self}#rebuild-profile
  '';
}

