{
  inputs,
  pkgs,
  ...
}: {
  environment.systemPackages = with inputs.nix-ai-tools.packages.${pkgs.system}; [
    claude-code
    claude-code-router
    qwen-code
    gemini-cli
    opencode
    pkgs.claude-usage-monitor
    pkgs.ccusage
    pkgs.bmad-method
  ];
}
