# Fail2Ban Service Coverage - Polarvortex VPS

**Last Updated:** 2026-01-11  
**System:** polarvortex.polarmutex.dev

---

## 📊 Service Coverage Summary

| Service | Authentication | Fail2Ban Coverage | Status |
|---------|---------------|-------------------|--------|
| **SSH** | SSH Keys | ✅ sshd jail | Protected |
| **Fava** | HTTP Basic Auth | ✅ nginx-http-auth jail | Protected |
| **Forgejo** | Built-in auth | ✅ forgejo-auth jail (custom) | Protected |
| **LiteLLM** | None visible | ⚠️ Not protected | Needs review |
| **Umami** | Unknown | ⚠️ Not protected | Needs review |
| **Nginx** | Rate limiting | ✅ nginx-limit-req jail | Protected |

---

## ✅ Protected Services

### 1. SSH (Direct Access)
**Port:** 22  
**Authentication:** SSH key-based  
**Fail2Ban Jail:** `sshd`

**Protection:**
- 3 failed authentication attempts within 10 minutes = 24h ban
- Progressive ban escalation (1h → 2h → 4h → ... → 1 week)
- Monitors: `/var/log/auth.log`

**Verification:**
```bash
sudo fail2ban-client status sshd
journalctl -u sshd | grep "Failed"
```

---

### 2. Fava (Beancount Ledger)
**URL:** `https://fava.polarmutex.dev`  
**Authentication:** HTTP Basic Auth (nginx)  
**Fail2Ban Jail:** `nginx-http-auth`

**Protection:**
- 5 failed HTTP auth attempts = ban
- Authentication handled at nginx level
- Monitors: `/var/log/nginx/error.log`

**Configuration:**
```nix
services.nginx.virtualHosts."fava.${domain}" = {
  basicAuthFile = cfg.fava.basicAuth.htpasswdFile;  # From sops secrets
};
```

**Verification:**
```bash
# Test with wrong password
curl -u wronguser:wrongpass https://fava.polarmutex.dev

# Check nginx logs
sudo journalctl -u nginx | grep "auth"

# Check if IP gets banned after 5 attempts
sudo fail2ban-client status nginx-http-auth
```

---

### 3. Forgejo (Git Forge)
**URL:** `https://git.polarmutex.dev`  
**Authentication:** Built-in username/password  
**Fail2Ban Jail:** `forgejo-auth` (custom filter)

**Protection:**
- 5 failed login attempts within 10 minutes = 1h ban
- Progressive ban escalation applies
- Monitors: `/var/lib/forgejo/log/forgejo.log`
- Custom filter: `/etc/fail2ban/filter.d/forgejo-auth.conf`

**Configuration:**
```nix
services.fail2ban.jails.forgejo-auth = {
  settings = {
    enabled = true;
    port = "http,https";
    filter = "forgejo-auth";
    logpath = "/var/lib/forgejo/log/forgejo.log";
    maxretry = 5;
    findtime = 600;
    bantime = 3600;
  };
};

environment.etc."fail2ban/filter.d/forgejo-auth.conf".text = ''
  [Definition]
  failregex = ^.*Failed authentication attempt.*from <HOST>.*$
              ^.*invalid credentials.*remote_addr=<HOST>.*$
  ignoreregex =
'';
```

**Security Settings:**
- Registration disabled: `DISABLE_REGISTRATION = true`
- Secure cookies: `COOKIE_SECURE = true`
- Admin account created via sops-nix secrets

**Verification:**
```bash
# Check Forgejo logs exist
ls -la /var/lib/forgejo/log/

# Check fail2ban jail status
sudo fail2ban-client status forgejo-auth

# Test failed login (manual via browser)
# Navigate to https://git.polarmutex.dev/user/login
# Try wrong credentials 5 times
# Verify IP is banned
```

**Note:** The failregex patterns may need adjustment based on actual Forgejo log format. After deployment, verify with:
```bash
# Check actual Forgejo log format
sudo tail -100 /var/lib/forgejo/log/forgejo.log | grep -i fail

# Test filter manually
sudo fail2ban-regex /var/lib/forgejo/log/forgejo.log /etc/fail2ban/filter.d/forgejo-auth.conf
```

---

### 4. Nginx Rate Limiting
**All Services**  
**Protection:** `nginx-limit-req` jail

**Configuration:**
- Rate limit zone: 10 requests/second per IP
- 10 violations = ban
- Monitors: `/var/log/nginx/error.log`

**Verification:**
```bash
sudo fail2ban-client status nginx-limit-req
journalctl -u nginx | grep "limiting requests"
```

---

## ⚠️ Services Requiring Review

### 1. LiteLLM (LLM Proxy)
**URL:** `https://litellm.polarmutex.dev`  
**Current State:** Proxied through nginx to localhost:4000  
**Authentication:** Not visible in configuration

**Security Concerns:**
- No HTTP Basic Auth configured at nginx level
- No fail2ban coverage for authentication failures
- Depends on LiteLLM application's built-in authentication

**Recommendations:**

**Option A: Add HTTP Basic Auth at nginx level (Recommended)**
```nix
services.nginx.virtualHosts."litellm.${domain}" = {
  forceSSL = true;
  enableACME = true;
  
  # Add basic auth
  basicAuthFile = "/path/to/htpasswd";  # Create via sops-nix
  
  locations."/" = {
    proxyPass = "http://127.0.0.1:4000";
  };
};
```
This automatically gets protected by existing `nginx-http-auth` jail.

**Option B: Restrict by IP**
```nix
services.nginx.virtualHosts."litellm.${domain}" = {
  locations."/" = {
    extraConfig = ''
      allow 1.2.3.4;  # Your trusted IP
      deny all;
    '';
  };
};
```

**Option C: Verify LiteLLM has built-in auth**
```bash
# Check LiteLLM configuration
cat /etc/litellm/config.yaml  # or wherever config is
# Look for: master_key, api_key, authentication settings
```

**Current Risk Level:** 🔴 HIGH (if no built-in auth)

---

### 2. Umami (Analytics)
**URL:** Unknown (not found in provided configs)  
**Current State:** Unknown

**Action Required:**
1. Verify if Umami is exposed externally
2. Check authentication mechanism
3. Add fail2ban coverage if needed

---

## 🔧 Fail2Ban Configuration

### Global Settings
```nix
services.fail2ban = {
  enable = true;
  maxretry = 3;
  bantime = "24h";
  bantime-increment = {
    enable = true;
    multipliers = "1 2 4 8 16 32 64";
    maxtime = "168h";  # 1 week maximum
    overalljails = true;  # Ban escalation applies across all jails
  };
};
```

### Progressive Ban Timeline
```
Offense 1: 24 hours
Offense 2: 48 hours (2 days)
Offense 3: 96 hours (4 days)
Offense 4: 192 hours (8 days) - capped at 168h (7 days)
Offense 5+: 168 hours (7 days maximum)
```

---

## 📊 Monitoring Commands

### Check All Jail Status
```bash
sudo fail2ban-client status
```

### Check Specific Jails
```bash
sudo fail2ban-client status sshd
sudo fail2ban-client status nginx-http-auth
sudo fail2ban-client status nginx-limit-req
sudo fail2ban-client status forgejo-auth
```

### View Banned IPs
```bash
# All jails
sudo fail2ban-client banned

# Specific jail
sudo fail2ban-client get sshd banned
sudo fail2ban-client get forgejo-auth banned
```

### Unban an IP
```bash
# Unban from specific jail
sudo fail2ban-client set sshd unbanip 1.2.3.4

# Unban from all jails
sudo fail2ban-client unban 1.2.3.4

# Unban all IPs
sudo fail2ban-client unban --all
```

### Check Logs
```bash
# Fail2ban service logs
journalctl -u fail2ban -f

# Recent bans
journalctl -u fail2ban | grep "Ban"

# Recent unbans
journalctl -u fail2ban | grep "Unban"
```

---

## 🧪 Testing Fail2Ban Coverage

### Test SSH Protection
```bash
# From another machine, try wrong SSH key 3 times
ssh -i wrong_key polar@polarvortex.polarmutex.dev

# Check if banned
sudo fail2ban-client status sshd
```

### Test Fava Protection
```bash
# Attempt wrong credentials 5 times
for i in {1..5}; do
  curl -u wrong:password https://fava.polarmutex.dev
  sleep 1
done

# Check if banned
sudo fail2ban-client status nginx-http-auth
```

### Test Forgejo Protection
**Manual test required:**
1. Navigate to `https://git.polarmutex.dev/user/login`
2. Attempt login with wrong credentials 5 times
3. Check fail2ban status: `sudo fail2ban-client status forgejo-auth`
4. Verify IP is banned

**After deployment, verify filter works:**
```bash
# Generate test log entry (simulate failed login)
# Then test filter
sudo fail2ban-regex /var/lib/forgejo/log/forgejo.log /etc/fail2ban/filter.d/forgejo-auth.conf
```

---

## 🔒 Security Recommendations

### Immediate Actions
1. ✅ **Forgejo coverage added** - Verify filter patterns after deployment
2. 🔴 **LiteLLM authentication** - Add HTTP Basic Auth or verify built-in auth
3. ⚠️ **Umami review** - Determine if exposed and needs protection

### Post-Deployment Verification
1. Test each jail with actual failed attempts
2. Verify Forgejo filter regex matches actual log format
3. Monitor fail2ban logs for false positives/negatives
4. Document any authentication mechanisms discovered

### Long-term
1. Consider adding fail2ban jails for any other services
2. Review ban times - may want to increase for repeat offenders
3. Consider geographic IP filtering for known attack sources
4. Regular review of banned IPs to identify attack patterns

---

## 📈 Attack Pattern Analysis

After system runs for a while, analyze patterns:

```bash
# Most banned IPs
sudo fail2ban-client status | grep "Banned IP" | sort | uniq -c | sort -rn

# Ban statistics by jail
for jail in sshd nginx-http-auth nginx-limit-req forgejo-auth; do
  echo "=== $jail ==="
  sudo fail2ban-client status $jail
done

# Recent attack timeline
journalctl -u fail2ban --since "7 days ago" | grep "Ban" | tail -50
```

---

## 🆘 Troubleshooting

### Jail Not Starting
```bash
# Check configuration
sudo fail2ban-client -d

# Test specific jail
sudo fail2ban-client start forgejo-auth
sudo fail2ban-client status forgejo-auth
```

### Filter Not Matching
```bash
# Test filter against log file
sudo fail2ban-regex /var/lib/forgejo/log/forgejo.log /etc/fail2ban/filter.d/forgejo-auth.conf

# Check actual log format
sudo tail -100 /var/lib/forgejo/log/forgejo.log
```

### Accidental Self-Ban
```bash
# Unban yourself immediately
sudo fail2ban-client unban YOUR_IP

# Or unban from specific jail
sudo fail2ban-client set sshd unbanip YOUR_IP
```

### Logs Not Found
```bash
# Verify log paths
ls -la /var/log/auth.log
ls -la /var/log/nginx/error.log
ls -la /var/lib/forgejo/log/

# Check systemd journal if file logging disabled
journalctl -u sshd
journalctl -u nginx
journalctl -u forgejo
```

---

**Last Updated:** 2026-01-11  
**Next Review:** After deployment - verify Forgejo filter and test LiteLLM auth
