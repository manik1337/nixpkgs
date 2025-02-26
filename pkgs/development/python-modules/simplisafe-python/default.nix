{ lib
, aiohttp
, aresponses
, asynctest
, backoff
, buildPythonPackage
, docutils
, fetchFromGitHub
, poetry-core
, pytest-aiohttp
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, pytz
, types-pytz
, voluptuous
, websockets
}:

buildPythonPackage rec {
  pname = "simplisafe-python";
  version = "2022.01.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = pname;
    rev = version;
    sha256 = "sha256-dU7zyLSqUX4AM1MLaF9zHbbc2EfsJDtzIwmzy/xiLu8=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    backoff
    docutils
    pytz
    types-pytz
    voluptuous
    websockets
  ];

  checkInputs = [
    aresponses
    asynctest
    pytest-aiohttp
    pytest-asyncio
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'docutils = "<0.18"' 'docutils = "*"'
  '';

  disabledTests = [
    # simplipy/api.py:253: InvalidCredentialsError
    "test_request_error_failed_retry"
    "test_update_error"
  ];

  disabledTestPaths = [
    # Ignore the examples as they are prefixed with test_
    "examples/"
  ];

  pythonImportsCheck = [
    "simplipy"
  ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Python library the SimpliSafe API";
    homepage = "https://simplisafe-python.readthedocs.io/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
