{ pkgs, ... }: pkgs.writeShellApplication {
  name = "rebuild-profile";
  text = ''
    printf "\n=> Rebuilding profile apps\n"

    if [ "$UID" != 0 ]; then
      set -x
      NIXPKGS_ALLOW_UNFREE=1 nix profile upgrade --all --impure
      set +x
    else
      echo "Nothing to be done for user '$USER'"
    fi
  '';
}
