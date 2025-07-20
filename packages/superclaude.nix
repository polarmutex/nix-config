{
  lib,
  python3,
  fetchPypi,
}:
python3.pkgs.buildPythonPackage rec {
  pname = "SuperClaude";
  version = "3.0.0.1";
  format = "wheel";

  src = fetchPypi {
    inherit pname version format;
    python = "py3";
    abi = "none";
    platform = "any";
    hash = "sha256-zsHGmI40V53+D3xIoKresMSZm21GzC73xVdvwV1gH2w=";
  };

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