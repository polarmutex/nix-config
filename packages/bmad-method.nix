{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:
buildNpmPackage rec {
  pname = "bmad-method";
  version = "4.40.0";

  src = fetchFromGitHub {
    owner = "bmad-code-org";
    repo = "BMAD-METHOD";
    rev = "v${version}";
    hash = "sha256-vb393zd5PwwAaa+WYCKnDvkdfc2Xl8bltVRqL7CofXM=";
  };

  npmDepsHash = "sha256-LMii419/tFS6nLFwxbq7eFFvzPBieVlVLZfm9MS/S/s=";

  # No build needed for this package
  dontBuild = true;

  meta = with lib; {
    description = "Universal AI agent framework for agile, AI-driven development";
    longDescription = ''
      BMAD-METHOD is a universal AI agent framework designed for agile,
      AI-driven development across multiple domains. It features agentic planning
      with dedicated AI agents (Analyst, PM, Architect) that collaborate to create
      detailed product requirements and architecture documents.

      Key features include:
      - Context-engineered development with Scrum Master transformation
      - Codebase Flattener Tool for AI model consumption
      - Support for expansion packs across different domains
      - Comprehensive documentation and community support
    '';
    homepage = "https://github.com/bmad-code-org/BMAD-METHOD";
    license = licenses.mit;
    maintainers = with maintainers; [polarmutex];
    mainProgram = "bmad-method";
    platforms = platforms.unix;
  };
}
