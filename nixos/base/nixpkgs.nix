{ inputs, ... }:

{
  nixpkgs.overlays = [
    inputs.jzbor-overlay.overlays.default
    inputs.marswm.overlays.default
  ];
}
