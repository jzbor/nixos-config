{ pkgs, pname, perSystem, ... }:

pkgs.writeShellApplication {
  name = pname;
  text = ''
    if [ "$#" != 1 ]; then
      echo "Usage: $0 <ssh-dest>" > /dev/stderr
      exit 1
    fi

    ${pkgs.rsync}/bin/rsync -rzL --chmod 700 ${perSystem.self.cip-home}/ "$1:~"
  '';
}
