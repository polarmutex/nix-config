{
  lib,
  python3,
  fetchFromGitHub,
}:
python3.pkgs.buildPythonPackage rec {
  pname = "SuperClaude";
  version = "4.1.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SuperClaude-Org";
    repo = "SuperClaude_Framework";
    rev = "v${version}";
    hash = "sha256-en1YmR58Vpnqa9ADHwh3tQYZsJJYKEH7P+984POQC/Y=";
  };

  build-system = with python3.pkgs; [
    hatchling
  ];

  dependencies = with python3.pkgs; [
    click
    pytest
    rich
  ];

  # Disable import check - module name may differ from package name
  # pythonImportsCheck = ["SuperClaude"];

  meta = {
    description = "A configuration framework that enhances Claude Code with specialized commands, cognitive personas, and development methodologies";
    homepage = "https://github.com/SuperClaude-Org/SuperClaude_Framework";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [];
    platforms = lib.platforms.all;
  };
}
