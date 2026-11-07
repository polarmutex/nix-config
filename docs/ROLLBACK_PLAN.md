# NixOS Security Updates - Rollback & Recovery Plan

**Date Created:** 2026-01-11  
**System:** polarvortex VPS  
**Current Generation:** 104 (as of 2026-01-11 15:31:12)  
**NixOS Version:** 25.11.20260107.d351d06 (Xantusia)

---

## Changes Applied

### SSH Hardening (openssh.nix)
- Enabled strict cryptographic algorithms (Curve25519, AES-GCM, HMAC-SHA2-ETM)
- Enforced key-only authentication (disabled password auth)
- Added connection limits (MaxAuthTries: 3, MaxStartups: 10:30:60)
- Disabled unnecessary features (X11, TCP forwarding, agent forwarding)
- Restricted access to user: `polar`

**Risk Level:** MEDIUM - SSH configuration changes could lock out access if misconfigured

---

## Pre-Deployment Checklist

Before applying changes to the VPS:

- [ ] Verify SSH key is properly configured for user `polar`
- [ ] Confirm SSH key is loaded in 1Password agent (`~/.1password/agent.sock`)
- [ ] Have VPS console access ready (via hosting provider control panel)
- [ ] Test dry-build completes successfully
- [ ] Review all changes in git diff
- [ ] Ensure you can authenticate via SSH key (test current connection)
- [ ] Have these rollback instructions accessible outside the VPS

---

## Rollback Methods

### Method 1: Immediate Rollback (If System Boots)

**Command:**
```bash
sudo nixos-rebuild switch --rollback
```

This will revert to generation 104 (previous working configuration).

**Verification:**
```bash
# Check current generation
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system | grep current

# Test SSH access
ssh polar@polarvortex.polarmutex.dev
```

---

### Method 2: Boot Menu Rollback (If System Won't Boot/SSH Fails)

**Steps:**
1. Access VPS console via hosting provider control panel
2. Reboot the server
3. At GRUB boot menu, select "NixOS - Configuration 104" (or earlier generation)
4. System will boot into previous working state
5. Once booted, make rollback permanent:
   ```bash
   sudo nixos-rebuild switch --rollback
   ```

---

### Method 3: Specific Generation Rollback

**List all generations:**
```bash
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
```

**Switch to specific generation (e.g., 104):**
```bash
sudo nix-env --switch-generation 104 --profile /nix/var/nix/profiles/system
sudo /nix/var/nix/profiles/system/bin/switch-to-configuration switch
```

---

### Method 4: Manual Configuration Revert (Git-based)

**View recent commits:**
```bash
cd /home/polar/repos/personal/nix-config/main
git log --oneline -10
```

**Revert specific file:**
```bash
# Revert openssh.nix to previous version
git checkout HEAD~1 modules/nixos/openssh.nix

# Rebuild with reverted config
sudo nixos-rebuild switch --flake .#polarvortex
```

**Alternative - Full git revert:**
```bash
git revert <commit-hash>
sudo nixos-rebuild switch --flake .#polarvortex
```

---

## Emergency Recovery Procedures

### Scenario 1: SSH Connection Refused After Update

**Symptoms:** Cannot SSH to server, connection refused/timeout

**Recovery Steps:**
1. Access VPS via console (hosting provider web console/VNC)
2. Login as `polar` directly at console
3. Check SSH service status:
   ```bash
   systemctl status sshd
   journalctl -u sshd -n 50
   ```
4. If SSH failed to start, check logs for errors
5. Rollback using Method 1 or Method 2
6. Restart SSH: `sudo systemctl restart sshd`

---

### Scenario 2: SSH Key Authentication Not Working

**Symptoms:** SSH prompts for password or rejects key

**Recovery Steps:**
1. Access VPS via console
2. Check SSH configuration:
   ```bash
   sudo sshd -T | grep -E "(passwordauth|pubkeyauth|allowusers)"
   ```
3. Verify SSH key exists:
   ```bash
   ls -la ~/.ssh/authorized_keys
   cat ~/.ssh/authorized_keys
   ```
4. Check SSH daemon logs:
   ```bash
   sudo journalctl -u sshd -f
   ```
5. Temporarily enable password auth (emergency only):
   ```bash
   # Edit /etc/ssh/sshd_config (temporary override)
   # Add: PasswordAuthentication yes
   sudo systemctl restart sshd
   ```
6. Once logged in via password, investigate key issue or rollback

---

### Scenario 3: System Won't Boot After Update

**Symptoms:** Server stuck at boot, kernel panic, or boot loop

**Recovery Steps:**
1. Access VPS console
2. At GRUB menu, select previous generation (104)
3. System should boot normally
4. Login and make rollback permanent
5. Investigate boot issue:
   ```bash
   journalctl -xb -1  # Previous boot logs
   systemctl --failed
   ```

---

### Scenario 4: Complete System Lockout

**Symptoms:** Cannot access via SSH or console, system unresponsive

**Recovery Steps:**
1. Contact hosting provider support
2. Request rescue mode / recovery console access
3. Mount system disk
4. Modify NixOS configuration manually
5. Or: Boot from rescue image and use previous generation

---

## Testing Before Full Deployment

### 1. Dry-Build Test
```bash
cd /home/polar/repos/personal/nix-config/main
sudo nixos-rebuild dry-build --flake .#polarvortex
```

**Expected:** Build completes successfully with no errors

---

### 2. Build Without Activation
```bash
sudo nixos-rebuild build --flake .#polarvortex
```

**Expected:** New system generation built in `/nix/store`, not activated

---

### 3. Test in VM (If Available)
```bash
nixos-rebuild build-vm --flake .#polarvortex
./result/bin/run-polarvortex-vm
```

**Expected:** VM boots and SSH works with key authentication

---

## Deployment Strategy (Recommended)

### Conservative Approach

**Step 1: Commit changes with clear message**
```bash
git add modules/nixos/openssh.nix
git commit -m "security: SSH hardening - strict crypto + key-only auth"
```

**Step 2: Test build**
```bash
sudo nixos-rebuild dry-build --flake .#polarvortex
```

**Step 3: Keep current SSH session open**
```bash
# In existing SSH session, run:
sudo nixos-rebuild switch --flake .#polarvortex
```

**Step 4: Test new SSH connection in parallel**
```bash
# In a NEW terminal (don't close old session):
ssh -v polar@polarvortex.polarmutex.dev
```

**Step 5: Verify connection works**
- If new SSH works: ✅ Success! Close old session
- If new SSH fails: ❌ Use old session to rollback immediately

---

## Verification Commands

**After successful deployment, verify:**

```bash
# Check SSH configuration
sudo sshd -T | grep -E "(passwordauth|kexalgorithms|ciphers|macs)"

# Verify only key auth enabled
sudo sshd -T | grep passwordauthentication
# Expected: passwordauthentication no

# Check allowed algorithms
sudo sshd -T | grep kexalgorithms
# Expected: curve25519-sha256,curve25519-sha256@libssh.org,diffie-hellman-group-exchange-sha256

# Test SSH connection
ssh -v polar@polarvortex.polarmutex.dev
# Should connect successfully with key authentication

# Check fail2ban status
sudo fail2ban-client status sshd
```

---

## Contact Information

**VPS Provider:** [Your hosting provider]  
**Console Access:** [Control panel URL]  
**Emergency Contact:** [Support phone/email]

---

## Post-Rollback Actions

If rollback was necessary:

1. Document what went wrong
2. Review error logs: `journalctl -u sshd -n 100`
3. Test configuration changes locally or in VM first
4. Verify SSH key configuration before retry
5. Consider gradual rollout (one change at a time)

---

## Generation History

Keep track of important generations:

| Generation | Date | Description | Status |
|------------|------|-------------|--------|
| 104 | 2026-01-11 15:31 | Last known good config | STABLE |
| 105 | TBD | SSH hardening applied | TESTING |

---

## Notes

- NixOS atomic rollback is one of its strongest features - use it confidently
- Always keep a working SSH session open when testing SSH changes
- VPS console access is your safety net - know how to access it
- Test changes in VM or local system first when possible
- Document any issues for future reference

---

## Quick Reference Card

**Emergency Commands:**
```bash
# Immediate rollback
sudo nixos-rebuild switch --rollback

# Check current generation
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system | grep current

# View SSH logs
sudo journalctl -u sshd -f

# Check SSH status
systemctl status sshd

# Test SSH config
sudo sshd -T

# List available generations at boot
# (Access GRUB menu during boot)
```

---

**Last Updated:** 2026-01-11  
**Maintained By:** polar  
**Review Frequency:** After each major system update
