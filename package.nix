{ flake, pkgs, pname }: pkgs.writeShellApplication {
  name =  pname;
  text = ''
      nix run ${flake}#rebuild-system
      nix run ${flake}#rebuild-home
      nix run ${flake}#rebuild-profile
  '';
}

