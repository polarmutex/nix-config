{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    unstable.claude-code
    claude-usage-monitor
    ccusage
    superclaude
  ];
}
