{
  lib,
  buildPythonPackage,
  fetchPypi,
  click,
  pip,
  setuptools,
  wheel,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "shiv";
  version = "1.0.7";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lHdX/iY4OuntoMV288uiRN+jcV7S9Jk1RLdYJF9xqxU=";
  };

  propagatedBuildInputs = [
    click
    pip
    setuptools
    wheel
  ];

  pythonImportsCheck = [ "shiv" ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # AssertionError
    "test_hello_world"
    "test_extend_pythonpath"
    "test_multiple_site_packages"
    "test_no_entrypoint"
    "test_results_are_binary_identical_with_env_and_build_id"
    "test_preamble"
    "test_preamble_no_pip"
    "test_alternate_root"
    "test_alternate_root_environment_variable"
  ];

  meta = with lib; {
    description = "Command line utility for building fully self contained Python zipapps";
    homepage = "https://github.com/linkedin/shiv";
    license = licenses.bsd2;
    maintainers = with maintainers; [ prusnak ];
  };
}
