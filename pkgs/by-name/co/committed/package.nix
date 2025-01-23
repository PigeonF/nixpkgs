{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  darwin,
  testers,
  nix-update-script,
  committed,
  git,
  zlib,
}:
let
  version = "1.1.5";
in
rustPlatform.buildRustPackage {
  pname = "committed";
  inherit version;

  src = fetchFromGitHub {
    owner = "crate-ci";
    repo = "committed";
    tag = "v${version}";
    hash = "sha256-puv64/btSEkxGNhGGkh2A08gI+EIHWjC+s+QQDKj/ZQ=";
  };
  cargoHash = "sha256-jJbJsVc4nYPfxH1KG/UeJhKLCYNIcr21MnNP6QoX9VY=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.Security
    zlib
  ];

  nativeCheckInputs = [
    git
  ];

  # Ensure libgit2 can read user.name and user.email for `git_signature_default`.
  # https://github.com/crate-ci/committed/blob/v1.1.5/crates/committed/tests/cmd.rs#L126
  preCheck = ''
    export HOME=export HOME=$(mktemp -d)
    git config --global user.name nobody
    git config --global user.email no@where
  '';

  passthru = {
    tests.version = testers.testVersion { package = committed; };
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://github.com/crate-ci/committed";
    changelog = "https://github.com/crate-ci/committed/blob/v${version}/CHANGELOG.md";
    description = "Nitpicking commit history since beabf39";
    mainProgram = "committed";
    license = [
      lib.licenses.asl20 # or
      lib.licenses.mit
    ];
    maintainers = [ lib.maintainers.pigeonf ];
  };
}
