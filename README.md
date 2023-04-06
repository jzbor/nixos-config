# My NixOS Flake
This flake contains only my OS configuration.
My [home-manager configuration](https://github.com/jzbor/home-config] and my [nix overlay](https://github.com/jzbor/nix-overlay) can be found separate repositories.
This flake also does not export any of its modules.

# Layout
The flake consists of mainly three directories:
* [`modules`](./modules) contains different configuration modules (the core configuration, desktop stuff etc.)
* [`hosts`](./hosts) contains host-specific configurations as well as modules for a generic desktop/laptop setup
* [`hardware`](./hardware) contains hardware-specific configurations, but is not really used at the moment thanks to the existence of [nixos-hardware](https://github.com/NixOS/nixos-hardware)
