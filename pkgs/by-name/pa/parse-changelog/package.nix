{
  fetchCrate,
  lib,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:

let
  pname = "parse-changelog";
  version = "0.6.11";
in

rustPlatform.buildRustPackage {
  inherit pname version;

  # Fetch from crates.io because upstream does not publish a `Cargo.lock`.
  src = fetchCrate {
    inherit pname version;
    hash = "sha256-B+uR+cZWsZ9ard1zQx5irfBAIvBfd2Vs11qT/MAlTKw=";
  };

  cargoHash = "sha256-VfwUga2cmRIFB2wsejqpzgCr/gXzNXwF2tjcyP06KFc=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/taiki-e/parse-changelog";
    changelog = "https://github.com/taiki-e/parse-changelog/blob/v${version}/CHANGELOG.md";
    description = "Simple changelog parser, written in Rust";
    mainProgram = "parse-changelog";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [
      pigeonf
    ];
  };
}
