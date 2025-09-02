{ inputs, ... }:

{
  nixpkgs.overlays = [
    inputs.parcels.overlays.default
    inputs.marswm.overlays.default
  ];
}
