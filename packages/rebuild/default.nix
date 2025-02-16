{ flake, pkgs, pname }: pkgs.writeShellApplication {
  name =  pname;
  text = ''
      if test -e /run/current-system/activate; then
        nix run ${flake}#rebuild-system
      fi
      nix run ${flake}#rebuild-home
      nix run ${flake}#rebuild-profile
  '';
}

