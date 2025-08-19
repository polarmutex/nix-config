{
  lib,
  python3,
  fetchFromGitHub,
}:
python3.pkgs.buildPythonPackage rec {
  pname = "SuperClaude";
  version = "4.0.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SuperClaude-Org";
    repo = "SuperClaude_Framework";
    rev = "v${version}";
    hash = "sha256-qyBcRXUqZWDWT+++3KLtHcrOMYjoBU7aQuruJjKm/nY=";
  };

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    # Add actual dependencies once we can inspect the package
  ];

  pythonImportsCheck = ["SuperClaude"];

  meta = {
    description = "A configuration framework that enhances Claude Code with specialized commands, cognitive personas, and development methodologies";
    homepage = "https://github.com/SuperClaude-Org/SuperClaude_Framework";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [];
    platforms = lib.platforms.all;
  };
}
