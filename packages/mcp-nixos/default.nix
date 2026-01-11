{
  lib,
  python3Packages,
  fetchFromGitHub,
}:
python3Packages.buildPythonApplication rec {
  pname = "mcp-nixos";
  version = "0.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "willieseabrook";
    repo = "mcp-nixos";
    rev = "v${version}";
    hash = "sha256-1zi6w3nfz6h3wqjpil9x3h1ilmvq8swvsagj1v5k4mj8g10200xx";
  };

  build-system = with python3Packages; [
    hatchling
  ];

  dependencies = with python3Packages; [
    mcp
    requests
    python-dotenv
    beautifulsoup4
    psutil
  ];

  pythonImportsCheck = ["mcp_nixos"];

  meta = with lib; {
    description = "MCP server for NixOS documentation and package search";
    homepage = "https://github.com/willieseabrook/mcp-nixos";
    license = licenses.mit;
    maintainers = [];
    mainProgram = "mcp-nixos";
    platforms = platforms.all;
  };
}
