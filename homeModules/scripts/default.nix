{ pkgs, inputs, ... }: {
  home.packages = [
    (pkgs.callPackage ./all.nix { inherit pkgs inputs; })
  ];
}
