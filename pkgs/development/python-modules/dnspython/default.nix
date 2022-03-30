{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools-scm
, pytestCheckHook
, cacert
}:

buildPythonPackage rec {
  pname = "dnspython";
  version = "2.2.1";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    extension = "tar.gz";
    sha256 = "sha256-D3VppKb/FRlYtkMEBx03DaoyQ9FZQae+7fDJ/lEFYD4=";
  };

  checkInputs = [
    pytestCheckHook
  ] ++ lib.optional stdenv.isDarwin [
    cacert
  ];

  disabledTests = [
    # dns.exception.SyntaxError: protocol not found
    "test_misc_good_WKS_text"
    # fails if IPv6 isn't available
    "test_resolver_override"

  # Tests that run inconsistently on darwin systems
  ] ++ lib.optionals stdenv.isDarwin [
    # 9 tests fail with: BlockingIOError: [Errno 35] Resource temporarily unavailable
    "testQueryUDP"
    # 6 tests fail with: dns.resolver.LifetimeTimeout: The resolution lifetime expired after ...
    "testResolveCacheHit"
    "testResolveTCP"
  ];

  nativeBuildInputs = [
    setuptools-scm
  ];

  pythonImportsCheck = [ "dns" ];

  meta = with lib; {
    description = "A DNS toolkit for Python";
    homepage = "https://www.dnspython.org";
    license = with licenses; [ isc ];
    maintainers = with maintainers; [ gador ];
  };
}
