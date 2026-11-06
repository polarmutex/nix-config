{
  lib,
  python3Packages,
  fetchFromGitHub,
}:
python3Packages.buildPythonApplication rec {
  pname = "mcp-nixos";
  version = "3.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "utensils";
    repo = "mcp-nixos";
    rev = "v${version}";
    hash = "sha256-EjSyb5FcVnZOW0qFbcvxzor/je02duSe/RhJsL5p+14=";
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
