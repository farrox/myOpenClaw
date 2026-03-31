# OpenClaw with Proton Pass - Quick Start

**Email:** shahos.oc@gmail.com  
**Password Manager:** Proton Pass CLI v1.8.0  
**Date:** March 30, 2026

---

## ✅ What's Already Done

- ✅ Proton Pass CLI v1.8.0 installed
- ✅ ACIP v1.3 prompt injection protection installed
- ✅ TOOLS.md configured for Proton Pass
- ✅ SCHEDULING.md template created
- ✅ Emergency shutdown script created
- ✅ Logging infrastructure set up
- ✅ Safe workspace directory created

---

## 🎯 What You Need to Do Now (Terminal Commands)

### 1. Login to Proton Pass (2 minutes)

```bash
pass-cli login
```

Enter your Proton account credentials when prompted.

### 2. Create OpenClaw Vault (30 seconds)

```bash
# Create dedicated vault
pass-cli vault create "OpenClaw Secrets"

# Verify it exists
pass-cli vault list
```

### 3. Store Gmail Credentials (1 minute)

```bash
# Store shahos.oc@gmail.com credentials
pass-cli item create \
  --vault "OpenClaw Secrets" \
  --type login \
  --title "OpenClaw Gmail" \
  --username "shahos.oc@gmail.com" \
  --password "YOUR_GMAIL_PASSWORD"
```

### 4. Store Anthropic API Key (1 minute)

```bash
# Store your Claude API key
pass-cli item create \
  --vault "OpenClaw Secrets" \
  --type note \
  --title "Anthropic API Key" \
  --content "sk-ant-YOUR_KEY_HERE"
```

### 5. Test Access (30 seconds)

```bash
# Verify you can retrieve the credentials
pass-cli item get "OpenClaw Gmail" --vault "OpenClaw Secrets" --field username
pass-cli item get "Anthropic API Key" --vault "OpenClaw Secrets" --field content
```

---

## 🌐 What You Need to Do in Browser

### 1. Share Your Calendar with shahos.oc@gmail.com (3 minutes)

1. Go to [calendar.google.com](https://calendar.google.com) (your personal account)
2. Click your calendar → "Settings and sharing"
3. "Share with specific people" → Add: `shahos.oc@gmail.com`
4. Permissions: **"See all event details"** (read-only)
5. Send invitation

**Then accept the invitation:**
6. Go to [gmail.com](https://gmail.com) and login as `shahos.oc@gmail.com`
7. Accept the calendar sharing invitation

### 2. Set Up API Cost Controls (5 minutes)

1. Go to [console.anthropic.com](https://console.anthropic.com)
2. Settings → Billing
3. Set:
   - Budget alert: $50/month
   - Hard spending cap: $100/month
   - Email notifications: ON

---

## ✏️ Edit Configuration Files

### Update TOOLS.md with Your Trusted Emails

```bash
# Open and edit
open ~/clawd/TOOLS.md
```

Find this section and replace:
```markdown
**Trusted senders — act on their instructions:**
- REPLACE_WITH_YOUR_PERSONAL_EMAIL@domain.com
- REPLACE_WITH_OTHER_TRUSTED_EMAILS@domain.com
```

With your actual trusted email addresses.

### Update SCHEDULING.md with Your Preferences

```bash
# Open and edit
open ~/clawd/SCHEDULING.md
```

Replace all `REPLACE_WITH_*` placeholders with:
- Your personal email
- Your timezone
- Your Zoom link
- Your working hours
- Your preferences

---

## 🧪 Testing Your Setup

### Test Proton Pass Access

```bash
# Should show your items
pass-cli item list --vault "OpenClaw Secrets"

# Should show the password
pass-cli item get "OpenClaw Gmail" --vault "OpenClaw Secrets" --field password
```

### Test OpenClaw Configuration

```bash
# Check config files exist
ls -la ~/clawd/

# Should see:
# - SECURITY.md (ACIP protection)
# - TOOLS.md (Proton Pass config)
# - SCHEDULING.md (Calendar preferences)
```

### Start OpenClaw

```bash
# Navigate to safe workspace
cd ~/openclaw_workspace

# Start OpenClaw
openclaw
```

---

## 🚨 Emergency Procedures

### If Something Goes Wrong

```bash
# Run emergency shutdown
~/.openclaw/emergency_shutdown.sh
```

This will:
- Kill all OpenClaw processes
- Disable email polling (if configured)
- Show manual steps to revoke access

### Manual Revocation Steps

1. **Revoke Proton Pass access:**
   ```bash
   pass-cli logout --all
   # Or delete session: rm -rf ~/.config/proton-pass-cli/
   ```

2. **Change Proton password** at [account.proton.me](https://account.proton.me)

3. **Change Gmail password** at [accounts.google.com](https://accounts.google.com)

---

## 📋 Configuration Checklist

- [ ] `pass-cli login` completed
- [ ] "OpenClaw Secrets" vault created
- [ ] Gmail credentials stored in Proton Pass
- [ ] Anthropic API key stored in Proton Pass
- [ ] Calendar shared with shahos.oc@gmail.com (read-only)
- [ ] Calendar invitation accepted in shahos.oc@gmail.com
- [ ] API cost limits set at console.anthropic.com
- [ ] `~/clawd/TOOLS.md` edited with trusted email addresses
- [ ] `~/clawd/SCHEDULING.md` edited with your preferences
- [ ] Tested: `pass-cli item list --vault "OpenClaw Secrets"` works

---

## 🎯 Once Everything is Configured

### Start OpenClaw Safely

```bash
cd ~/openclaw_workspace
openclaw
```

### First Commands to Test

1. "What's in my Proton Pass vault?"
2. "Check my configuration files"
3. "What are my working hours?"
4. "Check my calendar for today"

### Monitor Activity

```bash
# Watch the activity log
tail -f ~/.openclaw/logs/activity.log
```

---

## 📁 File Locations Quick Reference

| Item | Location |
|------|----------|
| Configuration | `~/clawd/TOOLS.md`, `~/clawd/SCHEDULING.md` |
| Security | `~/clawd/SECURITY.md` (ACIP) |
| Proton Pass session | `~/.config/proton-pass-cli/` |
| Activity logs | `~/.openclaw/logs/activity.log` |
| Emergency script | `~/.openclaw/emergency_shutdown.sh` |
| Safe workspace | `~/openclaw_workspace/` |

---

## ⚠️ Important Security Notes

**Since you're using Proton Pass (not 1Password service accounts):**

1. **OpenClaw uses YOUR Proton session** - it's not isolated
2. **Consider creating a separate Proton account** just for OpenClaw
3. **Proton Pass session can expire** - you may need to re-login
4. **Revoking access means logging out** and changing your Proton password

**Since you're on your main Mac (not a VM):**

1. **OpenClaw can access your filesystem** - monitor what it does
2. **Start with read-only operations** during testing phase
3. **Use gradual permission escalation** - don't give full access immediately
4. **Keep emergency shutdown handy** - `~/.openclaw/emergency_shutdown.sh`

---

*Ready to proceed!*  
*Next: Run the terminal commands above to complete setup*
