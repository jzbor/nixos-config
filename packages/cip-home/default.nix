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

          home.sessionVariables.TERMINAL = "xfce4-terminal";
          jzbor-home.programs.marswm.enable = true;
          programs.neovim.enable = true;
          programs.rofi.enable = true;
        };
      }

    ];
  };
  fakeHomeFiles = fakeHome.config.home-files;
  homePackages = pkgs.symlinkJoin {
    name = "home-packages";
    paths = [ (builtins.attrValues (import ./packages.nix { inherit pkgs perSystem; }))  ];
  };
in pkgs.stdenvNoCC.mkDerivation {
  name = pname;
  dontUnpack = true;
  dontInstall = true;
  buildPhase = ''
    mkdir -pv $out

    mkdir -pv $out/.config
    cp -rvL ${fakeHomeFiles}/.config/marswm $out/.config/marswm
    cp -rvL ${fakeHomeFiles}/.config/nvim $out/.config/nvim

    mkdir -pv $out/.local/bin $out/.local/share
    if [ -d "${homePackages}/bin" ]; then
      cp -rvL ${homePackages}/bin/* $out/.local/bin/
    fi
    if [ -d "${homePackages}/share" ]; then
      cp -rvL ${homePackages}/share/* $out/.local/share/
    fi

    mkdir -pv $out/.local/bin
    for script in $(find ${inputs.self}/modules/home/scripts -name '*.sh' -printf "%f\n" | sed 's/\.sh$//'); do
      cp -rvL ${inputs.self}/modules/home/scripts/$script.sh $out/.local/bin/$script
      chmod -v +x "$out/.local/bin/$script"
    done
    for script in $(find ${inputs.self}/modules/home/scripts -name '*.py' -printf "%f\n" | sed 's/\.py$//'); do
      cp -rvL ${inputs.self}/modules/home/scripts/$script.py $out/.local/bin/$script
      chmod -v +x "$out/.local/bin/$script"
    done

    cp -rvL ${./reinstall-programs.sh} $out/.local/bin/reinstall-programs
    chmod -v +x $out/.local/bin/reinstall-programs

    cp -rvL ${./bashrc} $out/.bashrc
    cp -rvL ${./aliases} $out/.aliases
    cp -rvL ${./profile} $out/.profile
    cp -rvL ${./xinitrc} $out/.xinitrc
  '';
  doCheck = true;
  dontPatchShebangs = true;
  checkPhase = ''
    echo
    echo "Checking for /nix/store paths..."
    ! ${pkgs.ripgrep}/bin/rg /nix/store $out
  '';
}
