# Security Monitoring Quick Reference Card

**System:** polarvortex.polarmutex.dev  
**Last Updated:** 2026-01-11

---

## 🚨 Daily Security Checks (5 minutes)

```bash
#!/bin/bash
# Save as: ~/scripts/daily-security-check.sh

echo "=== SSH Failed Attempts (Last 24h) ==="
sudo journalctl -u sshd --since "24 hours ago" | grep -i "failed password\|invalid user" | wc -l

echo -e "\n=== Fail2Ban Currently Banned IPs ==="
sudo fail2ban-client status sshd | grep "Banned IP"

echo -e "\n=== Firewall Rate Limit Drops (Last Hour) ==="
sudo journalctl -k --since "1 hour ago" | grep -i iptables | grep DROP | wc -l

echo -e "\n=== Successful SSH Logins (Last 24h) ==="
sudo journalctl -u sshd --since "24 hours ago" | grep "Accepted publickey" | tail -5

echo -e "\n=== Nginx Error Rate (Last Hour) ==="
sudo journalctl -u nginx --since "1 hour ago" | grep -i error | wc -l

echo -e "\n=== System Load ==="
uptime

echo -e "\n=== Disk Usage ==="
df -h / | tail -1

echo -e "\n=== Failed Services ==="
systemctl --failed
```

**Usage:**
```bash
chmod +x ~/scripts/daily-security-check.sh
~/scripts/daily-security-check.sh
```

---

## 🔍 Quick Status Commands

### SSH Security
```bash
# Failed login attempts today
sudo journalctl -u sshd --since today | grep -i failed | wc -l

# Last 10 successful logins
sudo journalctl -u sshd | grep "Accepted publickey" | tail -10

# Check SSH configuration
sudo sshd -T | grep -E "(passwordauth|allowusers|maxauthtries)"

# View active SSH sessions
who
w
```

### Fail2Ban Status
```bash
# Overall status
sudo fail2ban-client status

# SSH jail details
sudo fail2ban-client status sshd

# Currently banned IPs
sudo fail2ban-client get sshd banned

# Unban an IP (if needed)
sudo fail2ban-client set sshd unbanip 1.2.3.4

# View fail2ban logs
sudo journalctl -u fail2ban --since "1 hour ago"
```

### Firewall & Rate Limiting
```bash
# View iptables rules
sudo iptables -L INPUT -v -n | grep recent

# Check rate limit drops
sudo journalctl -k --since "1 hour ago" | grep iptables | grep DROP

# View recent tracked connections
sudo cat /proc/net/xt_recent/SSH
sudo cat /proc/net/xt_recent/HTTP
sudo cat /proc/net/xt_recent/HTTPS

# Count drops by port (last 24h)
sudo journalctl -k --since "24 hours ago" | grep "DPT=22" | wc -l
sudo journalctl -k --since "24 hours ago" | grep "DPT=443" | wc -l
```

### Web Services
```bash
# Nginx status
systemctl status nginx

# Recent nginx errors
sudo journalctl -u nginx --since "1 hour ago" | grep -i error

# Check security headers
curl -I https://polarvortex.polarmutex.dev | grep -E "Strict-Transport|X-Frame|X-Content-Type"

# Active connections
ss -tulpn | grep nginx

# Top IPs accessing the server
sudo journalctl -u nginx --since "24 hours ago" | grep -oP '\d+\.\d+\.\d+\.\d+' | sort | uniq -c | sort -rn | head -10
```

### System Security
```bash
# Check kernel hardening parameters
sysctl net.ipv4.tcp_syncookies        # Should be 1
sysctl kernel.dmesg_restrict           # Should be 1
sysctl kernel.kptr_restrict            # Should be 2
sysctl kernel.unprivileged_bpf_disabled # Should be 1

# View kernel security events
sudo dmesg | grep -i "protection\|denied\|security"

# Check for segfaults
sudo journalctl --since "24 hours ago" | grep -i segfault

# View authentication logs
sudo journalctl _COMM=sshd --since "24 hours ago"
```

### Auto-Updates
```bash
# Check update timer status
systemctl status nixos-upgrade.timer
systemctl list-timers nixos-upgrade

# When was last update?
journalctl -u nixos-upgrade.service | grep "Started\|Finished" | tail -4

# View last update log
sudo journalctl -u nixos-upgrade.service -n 100

# Manually trigger update (test)
sudo systemctl start nixos-upgrade.service
```

---

## 📊 Performance Monitoring

```bash
# System load
uptime
top -bn1 | head -20

# Memory usage
free -h

# Disk usage
df -h

# Disk I/O
iostat -x 1 3

# Network usage
ss -s
netstat -s | grep -i error

# Service resource usage
systemctl status nginx --no-pager
systemctl status postgresql --no-pager
systemctl status fail2ban --no-pager
```

---

## 🚨 Security Incident Response

### Suspicious SSH Activity Detected

```bash
# 1. View recent SSH attempts
sudo journalctl -u sshd --since "1 hour ago" | grep -E "Failed|Invalid"

# 2. Check currently banned IPs
sudo fail2ban-client status sshd

# 3. Manually ban an IP if needed
sudo fail2ban-client set sshd banip 1.2.3.4

# 4. Check active sessions
who
w

# 5. View SSH connections
ss -tn | grep :22

# 6. If compromised: kill all SSH sessions except yours
# pkill -u <compromised_user>
```

### DDoS Attack Suspected

```bash
# 1. Check rate limit drops
sudo journalctl -k --since "10 minutes ago" | grep iptables | grep DROP | wc -l

# 2. View top connecting IPs
sudo cat /proc/net/xt_recent/HTTP | head -20
sudo cat /proc/net/xt_recent/HTTPS | head -20

# 3. Check nginx connections
ss -tn | grep :443 | wc -l
ss -tn | grep :80 | wc -l

# 4. View nginx access pattern
sudo journalctl -u nginx --since "10 minutes ago" | tail -50

# 5. Manually block IPs if needed (temporary)
sudo iptables -I INPUT -s 1.2.3.4 -j DROP
```

### Service Down

```bash
# 1. Check failed services
systemctl --failed

# 2. View service status
systemctl status <service-name>

# 3. View recent logs
sudo journalctl -u <service-name> --since "1 hour ago"

# 4. Restart service
sudo systemctl restart <service-name>

# 5. If persistent, rollback
sudo nixos-rebuild switch --rollback
```

---

## 📈 Weekly Security Review

```bash
#!/bin/bash
# Save as: ~/scripts/weekly-security-review.sh

echo "=== Weekly Security Report ==="
echo "Generated: $(date)"
echo ""

echo "=== SSH Statistics (Last 7 Days) ==="
echo "Total failed attempts: $(sudo journalctl -u sshd --since "7 days ago" | grep -i failed | wc -l)"
echo "Total successful logins: $(sudo journalctl -u sshd --since "7 days ago" | grep "Accepted publickey" | wc -l)"
echo "Unique IPs attempted: $(sudo journalctl -u sshd --since "7 days ago" | grep -oP '\d+\.\d+\.\d+\.\d+' | sort -u | wc -l)"

echo -e "\n=== Fail2Ban Statistics ==="
sudo fail2ban-client status sshd

echo -e "\n=== Top 10 Attacking IPs (Last 7 Days) ==="
sudo journalctl -u sshd --since "7 days ago" | grep "Failed" | grep -oP '\d+\.\d+\.\d+\.\d+' | sort | uniq -c | sort -rn | head -10

echo -e "\n=== Firewall Drops (Last 7 Days) ==="
echo "Total drops: $(sudo journalctl -k --since "7 days ago" | grep iptables | grep DROP | wc -l)"

echo -e "\n=== System Updates ==="
echo "Last update check:"
sudo journalctl -u nixos-upgrade.timer | grep "Started\|Finished" | tail -2

echo -e "\n=== Service Health ==="
systemctl --failed

echo -e "\n=== Disk Space ==="
df -h /

echo -e "\n=== Memory Usage ==="
free -h

echo -e "\n=== Top Resource Consumers ==="
ps aux --sort=-%mem | head -6
```

---

## 🔔 Alert Thresholds (Manual Monitoring)

| Metric | Normal | Warning | Critical | Action |
|--------|--------|---------|----------|--------|
| SSH Failed Attempts/Day | <50 | 50-200 | >200 | Review fail2ban logs |
| Banned IPs | 0-10 | 10-50 | >50 | Investigate patterns |
| Firewall Drops/Hour | <100 | 100-500 | >500 | Check for DDoS |
| Nginx Errors/Hour | <10 | 10-50 | >50 | Review error logs |
| Disk Usage | <70% | 70-85% | >85% | Clean up logs |
| Memory Usage | <70% | 70-85% | >85% | Restart services |
| Load Average (15m) | <2.0 | 2.0-4.0 | >4.0 | Check processes |

---

## 📝 Log Locations

```bash
# System logs
/var/log/messages           # System messages (if exists)
journalctl                  # Systemd journal (primary)

# Service-specific
journalctl -u sshd          # SSH logs
journalctl -u nginx         # Nginx logs
journalctl -u fail2ban      # Fail2ban logs
journalctl -u postgresql    # PostgreSQL logs
journalctl -u firewall      # Firewall logs

# Nginx access/error logs
/var/log/nginx/access.log
/var/log/nginx/error.log

# Kernel logs
journalctl -k               # Kernel messages
dmesg                       # Kernel ring buffer
```

---

## 🔧 Useful Aliases

Add to `~/.bashrc` or `~/.zshrc`:

```bash
# Security monitoring aliases
alias sec-check='~/scripts/daily-security-check.sh'
alias sec-report='~/scripts/weekly-security-review.sh'
alias ssh-failed='sudo journalctl -u sshd --since "24 hours ago" | grep -i failed'
alias ssh-success='sudo journalctl -u sshd --since "24 hours ago" | grep "Accepted publickey"'
alias f2b-status='sudo fail2ban-client status sshd'
alias f2b-banned='sudo fail2ban-client get sshd banned'
alias fw-drops='sudo journalctl -k --since "1 hour ago" | grep iptables | grep DROP'
alias nginx-errors='sudo journalctl -u nginx --since "1 hour ago" | grep -i error'
alias sys-failed='systemctl --failed'
alias update-status='systemctl status nixos-upgrade.timer'
```

---

## 📲 Quick Emergency Commands

```bash
# Emergency: Block an IP immediately
sudo iptables -I INPUT -s 1.2.3.4 -j DROP

# Emergency: Unblock an IP
sudo iptables -D INPUT -s 1.2.3.4 -j DROP

# Emergency: View all manual IP blocks
sudo iptables -L INPUT -n --line-numbers | grep DROP

# Emergency: Remove manual block by line number
sudo iptables -D INPUT <line-number>

# Emergency: Restart networking
sudo systemctl restart systemd-networkd

# Emergency: Reload firewall
sudo systemctl restart firewall

# Emergency: Ban an IP with fail2ban
sudo fail2ban-client set sshd banip 1.2.3.4

# Emergency: Unban all IPs
sudo fail2ban-client unban --all

# Emergency: System rollback
sudo nixos-rebuild switch --rollback

# Emergency: Reboot system (last resort)
sudo reboot
```

---

## 🎯 Security Score Card (Self-Assessment)

Run weekly and aim for all ✅:

- [ ] No suspicious SSH login attempts (>200/day)
- [ ] No unexpected banned IPs (all known attackers)
- [ ] No excessive firewall drops (DDoS check)
- [ ] Security headers present on all sites
- [ ] Auto-updates running successfully
- [ ] No failed services
- [ ] Disk usage under 80%
- [ ] All logs rotating properly
- [ ] No kernel security warnings
- [ ] Backup verified (manual check)

---

## 📞 Support Resources

**NixOS Rollback:**
```bash
sudo nixos-rebuild switch --rollback
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
```

**Documentation:**
- Rollback Plan: `docs/ROLLBACK_PLAN.md`
- Security Summary: `docs/SECURITY_IMPROVEMENTS_SUMMARY.md`
- This Reference: `docs/SECURITY_MONITORING_QUICK_REFERENCE.md`

**Key Commands Memory:**
- SSH logs: `journalctl -u sshd`
- Fail2ban: `fail2ban-client status sshd`
- Firewall: `iptables -L INPUT -v -n`
- Services: `systemctl status <service>`
- Rollback: `nixos-rebuild switch --rollback`

---

**Last Updated:** 2026-01-11  
**Print and keep handy or bookmark this file!**
