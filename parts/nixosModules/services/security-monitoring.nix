{
  flake.nixosModules.security-monitoring = {
    config,
    lib,
    pkgs,
    ...
  }: let
    cfg = config.services.security-monitoring;

    # Security monitoring script
    monitoringScript = pkgs.writeShellScript "security-monitor" ''
      set -euo pipefail

      REPORT_FILE="/tmp/security-report-$(date +%Y%m%d-%H%M%S).txt"
      ALERT_THRESHOLD_SSH_FAILURES=50
      ALERT_THRESHOLD_FW_DROPS=1000

      echo "=== Security Monitoring Report ===" > "$REPORT_FILE"
      echo "Generated: $(date)" >> "$REPORT_FILE"
      echo "" >> "$REPORT_FILE"

      # SSH Failed Attempts (Last 24h)
      SSH_FAILURES=$(${pkgs.systemd}/bin/journalctl -u sshd --since "24 hours ago" | ${pkgs.gnugrep}/bin/grep -ic "failed\|invalid" || true)
      echo "SSH Failed Attempts (24h): $SSH_FAILURES" >> "$REPORT_FILE"

      if [ "$SSH_FAILURES" -gt "$ALERT_THRESHOLD_SSH_FAILURES" ]; then
        echo "⚠️  WARNING: High SSH failure rate detected!" >> "$REPORT_FILE"
        echo "" >> "$REPORT_FILE"
        echo "Top 10 attacking IPs:" >> "$REPORT_FILE"
        ${pkgs.systemd}/bin/journalctl -u sshd --since "24 hours ago" | \
          ${pkgs.gnugrep}/bin/grep -i "failed" | \
          ${pkgs.gnugrep}/bin/grep -oP '\d+\.\d+\.\d+\.\d+' | \
          ${pkgs.coreutils}/bin/sort | ${pkgs.coreutils}/bin/uniq -c | \
          ${pkgs.coreutils}/bin/sort -rn | ${pkgs.coreutils}/bin/head -10 >> "$REPORT_FILE" || true
      fi
      echo "" >> "$REPORT_FILE"

      # Successful SSH Logins
      SSH_SUCCESS=$(${pkgs.systemd}/bin/journalctl -u sshd --since "24 hours ago" | ${pkgs.gnugrep}/bin/grep -ic "accepted publickey" || true)
      echo "SSH Successful Logins (24h): $SSH_SUCCESS" >> "$REPORT_FILE"
      echo "" >> "$REPORT_FILE"

      # Fail2Ban Status
      echo "=== Fail2Ban Status ===" >> "$REPORT_FILE"
      ${pkgs.fail2ban}/bin/fail2ban-client status sshd 2>/dev/null | \
        ${pkgs.gnugrep}/bin/grep -E "Currently banned|Total banned" >> "$REPORT_FILE" || echo "Fail2Ban not responding" >> "$REPORT_FILE"
      echo "" >> "$REPORT_FILE"

      # Firewall Drops (Last 24h)
      FW_DROPS=$(${pkgs.systemd}/bin/journalctl -k --since "24 hours ago" | ${pkgs.gnugrep}/bin/grep -ic "DROP" || true)
      echo "Firewall Drops (24h): $FW_DROPS" >> "$REPORT_FILE"

      if [ "$FW_DROPS" -gt "$ALERT_THRESHOLD_FW_DROPS" ]; then
        echo "⚠️  WARNING: High firewall drop rate detected!" >> "$REPORT_FILE"
      fi
      echo "" >> "$REPORT_FILE"

      # Nginx Errors (Last 24h)
      NGINX_ERRORS=$(${pkgs.systemd}/bin/journalctl -u nginx --since "24 hours ago" | ${pkgs.gnugrep}/bin/grep -ic "error" || true)
      echo "Nginx Errors (24h): $NGINX_ERRORS" >> "$REPORT_FILE"
      echo "" >> "$REPORT_FILE"

      # Failed Services
      echo "=== Failed Services ===" >> "$REPORT_FILE"
      ${pkgs.systemd}/bin/systemctl --failed --no-pager >> "$REPORT_FILE" || echo "No failed services" >> "$REPORT_FILE"
      echo "" >> "$REPORT_FILE"

      # Disk Usage
      echo "=== Disk Usage ===" >> "$REPORT_FILE"
      ${pkgs.coreutils}/bin/df -h / | ${pkgs.coreutils}/bin/tail -1 >> "$REPORT_FILE"
      DISK_USAGE=$(${pkgs.coreutils}/bin/df -h / | ${pkgs.coreutils}/bin/tail -1 | ${pkgs.gawk}/bin/awk '{print $5}' | ${pkgs.gnused}/bin/sed 's/%//')
      if [ "$DISK_USAGE" -gt 85 ]; then
        echo "⚠️  WARNING: Disk usage above 85%" >> "$REPORT_FILE"
      fi
      echo "" >> "$REPORT_FILE"

      # Memory Usage
      echo "=== Memory Usage ===" >> "$REPORT_FILE"
      ${pkgs.procps}/bin/free -h >> "$REPORT_FILE"
      echo "" >> "$REPORT_FILE"

      # System Load
      echo "=== System Load ===" >> "$REPORT_FILE"
      ${pkgs.coreutils}/bin/uptime >> "$REPORT_FILE"
      echo "" >> "$REPORT_FILE"

      # Auto-Update Status
      echo "=== Auto-Update Status ===" >> "$REPORT_FILE"
      ${pkgs.systemd}/bin/journalctl -u nixos-upgrade.service | \
        ${pkgs.gnugrep}/bin/grep -E "Started|Finished|Failed" | \
        ${pkgs.coreutils}/bin/tail -4 >> "$REPORT_FILE" || echo "No recent update activity" >> "$REPORT_FILE"
      echo "" >> "$REPORT_FILE"

      # Output report
      ${pkgs.coreutils}/bin/cat "$REPORT_FILE"

      # Log to journal
      echo "Security monitoring report generated at $REPORT_FILE" | ${pkgs.systemd}/bin/systemd-cat -t security-monitor -p info

      # Check if we need to send alerts (any warnings in report)
      if ${pkgs.gnugrep}/bin/grep -q "⚠️  WARNING" "$REPORT_FILE"; then
        echo "SECURITY ALERTS DETECTED - Review required" | ${pkgs.systemd}/bin/systemd-cat -t security-monitor -p warning
        exit 1  # Non-zero exit to trigger OnFailure if configured
      fi

      # Cleanup old reports (keep last 7 days)
      ${pkgs.findutils}/bin/find /tmp -name "security-report-*.txt" -mtime +7 -delete 2>/dev/null || true
    '';
  in {
    options.services.security-monitoring = {
      enable = lib.mkEnableOption "security monitoring and alerting";

      schedule = lib.mkOption {
        type = lib.types.str;
        default = "daily";
        description = "When to run security monitoring (systemd timer format)";
        example = "hourly";
      };
    };

    config = lib.mkIf cfg.enable {
      # Security monitoring service
      systemd.services.security-monitor = {
        description = "Security Monitoring and Alerting";
        wants = ["network-online.target"];
        after = ["network-online.target"];

        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${monitoringScript}";

          # Security hardening
          NoNewPrivileges = true;
          PrivateTmp = true;
          ProtectSystem = "strict";
          ProtectHome = true;
          ReadWritePaths = ["/tmp"];

          # Allow reading logs
          SupplementaryGroups = ["systemd-journal"];
        };
      };

      # Timer for periodic monitoring
      systemd.timers.security-monitor = {
        description = "Security Monitoring Timer";
        wantedBy = ["timers.target"];

        timerConfig = {
          OnCalendar = cfg.schedule;
          Persistent = true;
          RandomizedDelaySec = "5m"; # Spread load
        };
      };
    };
  };
}
