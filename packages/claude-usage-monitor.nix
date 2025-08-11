{
  lib,
  python3Packages,
  fetchFromGitHub,
}:
python3Packages.buildPythonApplication rec {
  pname = "claude-usage-monitor";
  version = "3.1.0";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Maciek-roboblog";
    repo = "Claude-Code-Usage-Monitor";
    rev = "v${version}";
    hash = "sha256-v5ooniaN1iVerBW77/00SpghIVE1j8cl2WENcPnS66M=";
  };

  nativeBuildInputs = with python3Packages; [
    setuptools
  ];

  propagatedBuildInputs = with python3Packages; [
    pytz
    rich
    numpy
    pydantic
    pydantic-settings
    pyyaml
  ];

  # Tests require Claude API access and local data files
  doCheck = false;

  pythonImportsCheck = [
    "claude_monitor"
  ];

  meta = with lib; {
    description = "Real-time terminal monitoring tool for Claude AI token usage";
    longDescription = ''
      Claude Monitor is a real-time terminal application that tracks Claude AI token
      usage by reading local usage data files. It provides live monitoring of token
      consumption, burn rate analysis, and usage predictions without requiring
      external API access or network connectivity.
      The tool reads usage metadata from local JSONL files that Claude Desktop
      automatically creates, ensuring privacy by only accessing usage statistics
      rather than conversation content.
    '';
    homepage = "https://github.com/Maciek-roboblog/Claude-Code-Usage-Monitor";
    changelog = "https://github.com/Maciek-roboblog/Claude-Code-Usage-Monitor/blob/main/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [polarmutex];
    mainProgram = "claude-monitor";
    platforms = platforms.unix;
  };
}
