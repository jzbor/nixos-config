{ flake, inputs, pkgs, pname, perSystem, ... }:

let
  fakeHome = inputs.home-manager.lib.homeManagerConfiguration {
    inherit pkgs;

    extraSpecialArgs = { inherit perSystem inputs; };

    modules = [

      flake.homeModules.programs
      flake.homeModules.theming

      {
        config = {
          home.stateVersion = "25.05";
          home.username = "nobody";
          home.homeDirectory = "/dev/null";

          jzbor-home.programs.marswm.enable = true;
          programs.neovim.enable = true;
        };
      }

    ];
  };
  fakeHomeFiles = fakeHome.config.home-files;
in pkgs.stdenvNoCC.mkDerivation {
  name = pname;
  dontUnpack = true;
  dontInstall = true;
  buildPhase = ''
    mkdir -pv $out

    mkdir -pv $out/.config
    cp -rvL ${fakeHomeFiles}/.config/marswm $out/.config/marswm
    cp -rvL ${fakeHomeFiles}/.config/nvim $out/.config/nvim

    mkdir -pv $out/.local/bin
    for script in $(find ${inputs.self}/modules/home/scripts -name '*.sh' -printf "%f\n" | sed 's/\.sh$//'); do
      cp -rvL ${inputs.self}/modules/home/scripts/$script.sh $out/.local/bin/$script
      chmod -v +x "$out/.local/bin/$script"
    done
  '';
  doCheck = true;
  checkPhase = ''
    echo
    echo "Checking for /nix/store paths..."
    ! ${pkgs.ripgrep}/bin/rg /nix/store $out
  '';
}
