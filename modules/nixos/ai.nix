{
  inputs,
  pkgs,
  ...
}: {
  environment.systemPackages = with inputs.nix-ai-tools.packages.${pkgs.system}; [
    claude-code
    claude-code-router
    qwen-code
    pkgs.claude-usage-monitor
    pkgs.ccusage
  ];
}
