{
  lib,
  buildGo127Module,
  fetchFromGitHub,
}:
buildGo127Module rec {
  pname = "github-mcp-server";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "github";
    repo = "github-mcp-server";
    rev = "v${version}";
    hash = "sha256-yMwLpdl8Zw+sAn+6IoFGdSHD2pjENYVrLrSWOzHJCLw=";
  };

  vendorHash = "sha256-2RfJhHB5dL8fHZY1gunVRAGGA3pOAA1YOeyi40Tfovc=";

  subPackages = [ "cmd/github-mcp-server" ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "MCP server for GitHub API integration";
    homepage = "https://github.com/github/github-mcp-server";
    license = licenses.mit;
    maintainers = [];
    mainProgram = "github-mcp-server";
    platforms = platforms.all;
  };
}
