{
  inputs,
  pkgs,
  ...
}: {
  environment.systemPackages = with inputs.nix-ai-tools.packages.${pkgs.stdenv.hostPlatform.system}; [
    claude-code-router
    qwen-code
    opencode
    # pkgs.superclaude
    # pkgs.claude-usage-monitor
    # pkgs.ccusage
    # pkgs.bmad-method
    pkgs.claude-code
    gemini-cli
  ];
}
