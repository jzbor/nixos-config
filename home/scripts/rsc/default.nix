{ rustPlatform, ... }:

rustPlatform.buildRustPackage {
  name = "rust-script-collection";
  src = ./.;
  cargoHash = "sha256-aitx8szwEr6XQ068GoCoPaHsJ16Fp/uigurI0tmb1Ig=";
}
