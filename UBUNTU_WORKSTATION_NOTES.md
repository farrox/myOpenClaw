# Ubuntu workstation notes (`mypc`)

Household Ubuntu desktop + SSH + RDP patterns that worked on **22.04 Jammy** (and to re-verify after **24.04 Noble** upgrade).

**Source of truth for this machine:** this file in the **`myOpenClaw`** repo: **`UBUNTU_WORKSTATION_NOTES.md`** (repo root). After `git clone`, it is **`…/myOpenClaw/UBUNTU_WORKSTATION_NOTES.md`** (e.g. **`~/Developer/myOpenClaw/UBUNTU_WORKSTATION_NOTES.md`** on **`ed@mypc`**). Prefer it over ad-hoc shell snippets when aligning OpenClaw, SSH, RDP, and firewall steps.

**Primary Linux user for OpenClaw / SSH:** **`ed`** (home **`/home/ed`**).

---

## OpenClaw-related paths and tooling (user `ed`)

These are **expected to be missing** until setup is finished:

| Path / check | Meaning |
|--------------|---------|
| **`/home/ed/clawd`** | Agent workspace (create per **`LLM_ASSISTANT_SETUP_GUIDE.md`** / **`SETUP_GUIDE.md`**). |
| **`~/.openclaw/`** | OpenClaw config + state (created by **`openclaw onboard`** / first run). |
| **`openclaw` on `PATH`** | Installed with **`npm install -g openclaw`** after Node is available. |

**Proton Pass CLI (`pass-cli`):** install and login per **`PROTON_PASS_SETUP.md`** and **`QUICK_START_PROTON.md`** in this repo. The binary often ends up under **`~/.local/bin/pass-cli`**; **`which pass-cli`** must succeed in the **same** environment that runs the gateway (terminal, systemd user unit, or login session).

---

## Shell and `PATH` (non-interactive vs login)

Remote assistants sometimes run **`bash -lc '…'`** (non-login, non-interactive). On a typical **nvm** + **Debian/Ubuntu** setup, **Node**, **npm**, **globally installed CLIs** (e.g. **`openclaw`**), and sometimes **`pass-cli`** are only appended to **`PATH`** from **`~/.bashrc`** or after **`nvm.sh`** is sourced—so they **will not appear** in a bare **`bash -lc`** check.

**Do this instead when verifying tools:**

1. **Interactive SSH (recommended):** `ssh -t ed@mypc.home` then run `which node`, `which npm`, `which openclaw`, `which pass-cli`, `node -v`.
2. **Login shell one-liner:** `ssh ed@mypc.home 'bash -l -c "command -v node; command -v openclaw; command -v pass-cli"'` (note **`-l`**).
3. If you must use a non-login shell, source nvm explicitly, e.g.  
   `source "$HOME/.nvm/nvm.sh" && command -v node && command -v openclaw`

**Goal:** match how **`ed`** actually starts the gateway (interactive terminal, tmux, or desktop shortcut)—that environment’s **`PATH`** is what matters.

**Node install method on this class of machine:** **[nvm](https://github.com/nvm-sh/nvm)** + **Node 22** (or current LTS), then **`npm install -g openclaw`**. Do **not** use **`sudo npm install -g`** with nvm’s Node. The nvm installer appends to **`~/.bashrc`**, but Debian/Ubuntu **`~/.bashrc`** often **returns immediately** for non-interactive shells—so **`bash -l -c 'command -v node'`** may still fail unless **`nvm.sh`** is also sourced from **`~/.profile`** (before or independent of the interactive guard). For **GUI-launched** apps that need `node`/`openclaw` on `PATH`, you may also need your desktop environment’s session **`PATH`**—see **`LLM_ASSISTANT_SETUP_GUIDE.md`** §1 and **`ubuntu_status.md`** for what was applied on **`mypc`**.

---

## Firewall (`ufw`) — optional

If **`ufw`** is enabled, typical home LAN pattern:

- **`sudo ufw allow OpenSSH`** (or **`sudo ufw allow 22/tcp`**) before enabling, so SSH is not locked out.
- **`sudo ufw enable`** / **`sudo ufw status`** to confirm.

Adjust for **Tailscale**, **WireGuard**, or **non-default SSH ports** as needed.

---

## After a release upgrade (22.04 → 24.04)

1. **Reboot** and log in locally or via SSH.
2. **SSH:** `ssh ed@mypc.home` (or IP). If it fails, use **local console** or **UniFi** to fix `sshd` / keys.
3. **NVIDIA (GTX 780 / Kepler):** only **470** series is appropriate; prefer **`nvidia-driver-470`** (uses **DKMS**) if prebuilt `linux-modules-nvidia-470-*` meta packages hit **signature / version skew** errors.
4. **Verify GPU:** `nvidia-smi`
5. **DKMS:** after a **new kernel**, if the module is missing: `sudo dkms status` and reinstall/rebuild as needed.
6. **xrdp + desktop session:** ensure `/etc/xrdp/startwm.sh` launches a real session. Common choices:
   - **XFCE:** end with **`exec startxfce4`** (and `unset DBUS_SESSION_BUS_ADDRESS` / `XDG_RUNTIME_DIR` if needed) to avoid black-screen disconnects.
   - **Cinnamon (used on `mypc` in some setups):** e.g. **`exec cinnamon-session-cinnamon`**; keep local changes when **`dpkg`** asks to overwrite **`startwm.sh`** (**`N`**). Mirror **`~/.xsession`** for the RDP user if needed.
7. **Polkit / colord popup** over RDP: optional rule under `/etc/polkit-1/rules.d/` for `org.freedesktop.color-manager` (see conversation / polkit docs).

## Git + GitHub (SSH)

- Key: `~/.ssh/id_ed25519_github` with comment e.g. `edshahos@proton.me`
- `~/.ssh/config`:

```sshconfig
Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519_github
  IdentitiesOnly yes
```

- Test: `ssh -T git@github.com`
- Repo remote: `git@github.com:farrox/myOpenClaw.git`

## GitHub Desktop (Linux)

- Official desktop is **Windows/macOS only**; on Linux use **shiftkey/desktop**.
- If **`apt.packages.shiftkey.dev`** hits **TLS / certificate mismatch**, use **`mirror.mwt.me`** feed or install the **`.deb` from [GitHub releases](https://github.com/shiftkey/desktop/releases)** with `curl` + `apt install ./…deb`.
- **`gnome-keyring`** helps sign-in in some desktop setups.

## APT hygiene (seen on this machine)

- Remove broken third-party lists (e.g. dead Launchpad PPAs) that make `apt update` fail.
- **Google Chrome** `.list` must use **`signed-by=`** and `/usr/share/keyrings/google-linux.gpg`.

## Optional useful packages

```bash
sudo apt install -y \
  git curl wget gnupg build-essential \
  openssh-server \
  xrdp xfce4 xfce4-goodies \
  google-chrome-stable
```

Add **`ufw`**, **`htop`**, **`tmux`**, **`ca-certificates`**, **`software-properties-common`** as needed.

## Hostname / DNS

- Machine hostname: **`mypc`**; UniFi **local DNS** may use **`mypc.home`**.
- Mac `~/.ssh/config` can use **`HostName mypc.home`** and **`User ed`**.

---

*Last updated: April 2, 2026 — re-validate commands on your Ubuntu version after `do-release-upgrade`.*
