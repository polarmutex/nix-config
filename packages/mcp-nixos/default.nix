{
  lib,
  python3Packages,
  fetchFromGitHub,
}:
python3Packages.buildPythonApplication rec {
  pname = "mcp-nixos";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "utensils";
    repo = "mcp-nixos";
    rev = "v${version}";
    hash = "sha256-rnpIDY/sy/uV+1dsW+MrFwAFE/RHg5K/6aa5k7Yt1Dc=";
  };

  build-system = with python3Packages; [
    hatchling
  ];

  dependencies = with python3Packages; [
    fastmcp
    requests
    beautifulsoup4
  ];

  pythonImportsCheck = ["mcp_nixos"];

  meta = with lib; {
    description = "MCP server for NixOS documentation and package search";
    homepage = "https://github.com/utensils/mcp-nixos";
    license = licenses.mit;
    maintainers = [];
    mainProgram = "mcp-nixos";
    platforms = platforms.all;
  };
}
