# Proton Pass Setup for OpenClaw

**OpenClaw Email:** shahos.oc@gmail.com  
**Password Manager:** Proton Pass CLI v1.8.0  
**Status:** CLI installed, ready for configuration

---

## Step 1: Login to Proton Pass

Run this in your terminal:

```bash
pass-cli login
```

**You'll be prompted for:**
- Your Proton account email
- Your Proton account password
- 2FA code (if enabled)

**Note:** This authenticates with YOUR Proton account. Proton Pass doesn't have "service accounts" like 1Password, so OpenClaw will use your Proton credentials. Make sure you're comfortable with this!

---

## Step 2: Create Vault for OpenClaw

After logging in:

```bash
# Create dedicated vault
pass-cli vault create "OpenClaw Secrets"

# Verify it was created
pass-cli vault list
```

You should see "OpenClaw Secrets" in the list.

---

## Step 3: Store OpenClaw's Google Credentials

```bash
# Store the Gmail credentials
pass-cli item create \
  --vault "OpenClaw Secrets" \
  --type login \
  --title "OpenClaw Gmail" \
  --username "shahos.oc@gmail.com" \
  --password "YOUR_GMAIL_PASSWORD_HERE"
```

---

## Step 4: Store API Keys (As Needed)

### For Anthropic API Key:

```bash
pass-cli item create \
  --vault "OpenClaw Secrets" \
  --type note \
  --title "Anthropic API Key" \
  --content "sk-ant-YOUR_KEY_HERE"
```

### For Other Services:

```bash
# Generic API key storage
pass-cli item create \
  --vault "OpenClaw Secrets" \
  --type note \
  --title "Service Name API Key" \
  --content "your-api-key-here"
```

---

## Step 5: Test Access

```bash
# List all items in vault
pass-cli item list --vault "OpenClaw Secrets"

# Retrieve a password
pass-cli item get "OpenClaw Gmail" --vault "OpenClaw Secrets" --field password

# Retrieve an API key
pass-cli item get "Anthropic API Key" --vault "OpenClaw Secrets" --field content
```

---

## Security Considerations

### ⚠️ Important Differences from 1Password

**Proton Pass Limitations:**
- ❌ No "service account" concept - uses YOUR Proton login
- ❌ OpenClaw will have access to all your Proton vaults (not just OpenClaw Secrets)
- ⚠️ If your Proton session expires, OpenClaw will lose access
- ⚠️ Revoking access means changing your Proton password

**Mitigation Strategies:**

1. **Create a separate Proton account** just for OpenClaw (recommended):
   - Go to [proton.me](https://proton.me) and create a new free account
   - Use it exclusively for OpenClaw
   - Share only necessary items between your accounts

2. **Use password-protected items** for extra security:
   ```bash
   pass-cli item create --vault "OpenClaw Secrets" --protected
   ```

3. **Regular audits:** Check what OpenClaw has accessed
   ```bash
   pass-cli item list --vault "OpenClaw Secrets"
   ```

### 🔒 Emergency Revocation

If you need to revoke OpenClaw's access:

```bash
# Logout from all sessions
pass-cli logout --all

# Or delete the session
rm -rf ~/.config/proton-pass-cli/
```

Then change your Proton password at [account.proton.me](https://account.proton.me)

---

## Usage in OpenClaw

OpenClaw will use these commands (already configured in `~/clawd/TOOLS.md`):

```bash
# Get a password
pass-cli item get "Service Name" --vault "OpenClaw Secrets" --field password

# Get API key
pass-cli item get "API Key Name" --vault "OpenClaw Secrets" --field content

# Inject secrets into environment
export API_KEY=$(pass-cli item get "Anthropic API Key" --vault "OpenClaw Secrets" --field content)
```

---

## Quick Reference

| Command | Purpose |
|---------|---------|
| `pass-cli login` | Authenticate with Proton |
| `pass-cli vault list` | Show all vaults |
| `pass-cli item list --vault "OpenClaw Secrets"` | Show items in vault |
| `pass-cli item get "Name" --vault "OpenClaw Secrets" --field password` | Get password |
| `pass-cli item create --vault "OpenClaw Secrets" --type login --title "Name"` | Store new login |
| `pass-cli logout` | Logout |

---

## Next Steps

1. ✅ Proton Pass CLI installed
2. ⏳ **You need to:** Run `pass-cli login` in your terminal
3. ⏳ **You need to:** Create "OpenClaw Secrets" vault
4. ⏳ **You need to:** Store Gmail credentials for shahos.oc@gmail.com

---

*Created: March 30, 2026*
