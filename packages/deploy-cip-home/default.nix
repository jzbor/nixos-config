{ pkgs, systemPackages, ... }:

pkgs.writeShellApplication {
  name = "deploy-cip-home";
  text = ''
    if [ "$#" != 1 ]; then
      echo "Usage: $0 <ssh-dest>" > /dev/stderr
      exit 1
    fi

    ${pkgs.rsync}/bin/rsync -rzL --chmod 700 ${systemPackages.self.cip-home}/ "$1:~"
  '';
}
