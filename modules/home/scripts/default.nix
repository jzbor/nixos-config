{ pkgs, inputs, perSystem, ... }: {
  home.packages = [
    (pkgs.callPackage ./all.nix { inherit pkgs inputs perSystem; })
  ];
}
