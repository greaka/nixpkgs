{ lib
, buildPythonPackage
, fetchPypi
, findutils
, pytestCheckHook
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "extension-helpers";
  version = "1.0.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-yhv6xnx5z0p6DAkobOKiTuwxvxdxWBjQcmMY3Q5QUOY=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  patches = [ ./permissions.patch ];

  checkInputs = [ findutils pytestCheckHook ];

  # avoid import mismatch errors, as conftest.py is copied to build dir
  pytestFlagsArray = [
    "extension_helpers"
  ];

  pythonImportsCheck = [
    "extension_helpers"
  ];

  meta = with lib; {
    description = "Utilities for building and installing packages in the Astropy ecosystem";
    homepage = "https://github.com/astropy/extension-helpers";
    license = licenses.bsd3;
    maintainers = [ maintainers.rmcgibbo ];
  };
}
