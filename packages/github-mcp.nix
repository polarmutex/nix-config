{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "github-mcp-server";
  version = "0.27.0";

  src = fetchFromGitHub {
    owner = "github";
    repo = "github-mcp-server";
    rev = "v${version}";
    hash = "sha256-4HH6NujcVt9tAUn7jLB1Qcn2ADhszVZtDUt9IWl7j3U=";
  };

  vendorHash = "sha256-LlNL8/+B1QDe+/AbonNPxAvR2I+92+V2sKSBIghfRJU=";

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
