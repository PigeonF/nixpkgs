{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  makeWrapper,
  darwin,
  valgrind-light,
}:

rustPlatform.buildRustPackage rec {
  pname = "iai-callgrind-runner";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "iai-callgrind";
    repo = "iai-callgrind";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-NUFbA927Iye8DnmBWAQNiFmEen/a0931XlT+9gAQSV4=";
  };

  cargoHash = "sha256-Fo76fAx5hvomFeWPGyJKdXhsaGtAmmoOU8CauZvu64I=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  cargoBuildFlags = [
    "--bin"
    "iai-callgrind-runner"
  ];

  preCheck =
    # Required for client-request-tests
    ''
      export IAI_CALLGRIND_VALGRIND_PATH=${lib.makeBinPath [ valgrind-light ]}
      export IAI_CALLGRIND_VALGRIND_INCLUDE=${lib.makeIncludePath [ valgrind-light ]}
    ''
    # Prevent https://github.com/iai-callgrind/iai-callgrind/blob/v0.14.0/iai-callgrind-runner/src/main.rs#L15-L19
    # from messing up the stderr fixtures
    + ''
      unset RUST_LOG
    '';

  checkFlags = [
    # Mismatch between number of leaked bytes
    "--skip=test_client_requests::memcheck::test_memcheck_reqs_when_running_on_valgrind"
  ];

  nativeBuildInputs = [
    makeWrapper
    rustPlatform.bindgenHook
  ];

  postInstall = ''
    wrapProgram $out/bin/${pname} \
      --prefix PATH : ${lib.makeBinPath [ valgrind-light ]} \
      --set-default IAI_CALLGRIND_VALGRIND_INCLUDE ${lib.makeIncludePath [ valgrind-light ]}
  '';

  meta = {
    description = "Binary package needed by the iai-callgrind library";
    mainProgram = "iai-callgrind-runner";
    homepage = "https://github.com/iai-callgrind/iai-callgrind";
    license = [
      lib.licenses.asl20 # or
      lib.licenses.mit
    ];
    maintainers = [ lib.maintainers.pigeonf ];
  };
}
