{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "github-mcp-server";
  version = "0.30.2";

  src = fetchFromGitHub {
    owner = "github";
    repo = "github-mcp-server";
    rev = "v${version}";
    hash = "sha256-o3EGmImAjiTQTd/iwCiDArj4fPfS+8aArEF7KQNZK8I=";
  };

  vendorHash = "sha256-rv7mZQ2/j4R9s3p+Psq5E2I99zFtnieGc3eaMT3ykqQ=";

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
