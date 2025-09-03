{ self, inputs, pkgs, ... }:

let
  fakeHome = inputs.home-manager.lib.homeManagerConfiguration {
    inherit pkgs;

    extraSpecialArgs = { inherit inputs; };

    modules = [

      self.homeModules.programs
      self.homeModules.theming

      {
        config = {
          home.stateVersion = "25.05";
          home.username = "nobody";
          home.homeDirectory = "/dev/null";

          home.sessionVariables.TERMINAL = "xfce4-terminal";
          jzbor-home.programs.marswm.enable = true;
          jzbor-home.programs.vis.enable = true;
          programs.neovim.enable = true;
          programs.rofi.enable = true;
        };
      }

    ];
  };
  fakeHomeFiles = fakeHome.config.home-files;
  homePackages = pkgs.symlinkJoin {
    name = "home-packages";
    paths = [ (builtins.attrValues (import ./packages.nix { inherit pkgs; }))  ];
  };
in pkgs.stdenvNoCC.mkDerivation {
  name = "cip-home";
  dontUnpack = true;
  dontInstall = true;
  buildPhase = ''
    mkdir -pv $out

    mkdir -pv $out/.config
    cp -rvL ${fakeHomeFiles}/.config/marswm $out/.config/marswm
    cp -rvL ${fakeHomeFiles}/.config/nvim $out/.config/nvim
    cp -rvL ${fakeHomeFiles}/.config/vis $out/.config/vis

    mkdir -pv $out/.local/bin $out/.local/share
    if [ -d "${homePackages}/bin" ]; then
      cp -rvL ${homePackages}/bin/* $out/.local/bin/
    fi
    if [ -d "${homePackages}/share" ]; then
      cp -rvL ${homePackages}/share/* $out/.local/share/
    fi

    mkdir -pv $out/.local/bin
    for script in $(find ${inputs.self}/homeModules/scripts -name '*.sh' -printf "%f\n" | sed 's/\.sh$//'); do
      cp -rvL ${inputs.self}/homeModules/scripts/$script.sh $out/.local/bin/$script
      chmod -v +x "$out/.local/bin/$script"
    done
    for script in $(find ${inputs.self}/homeModules/scripts -name '*.py' -printf "%f\n" | sed 's/\.py$//'); do
      cp -rvL ${inputs.self}/homeModules/scripts/$script.py $out/.local/bin/$script
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
