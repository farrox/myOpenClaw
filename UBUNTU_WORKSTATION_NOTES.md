# Ubuntu workstation notes (`mypc`)

Household Ubuntu desktop + SSH + RDP patterns that worked on **22.04 Jammy** (and to re-verify after **24.04** upgrade).

## After a release upgrade (22.04 → 24.04)

1. **Reboot** and log in locally or via SSH.
2. **SSH:** `ssh ed@mypc.home` (or IP). If it fails, use **local console** or **UniFi** to fix `sshd` / keys.
3. **NVIDIA (GTX 780 / Kepler):** only **470** series is appropriate; prefer **`nvidia-driver-470`** (uses **DKMS**) if prebuilt `linux-modules-nvidia-470-*` meta packages hit **signature / version skew** errors.
4. **Verify GPU:** `nvidia-smi`
5. **DKMS:** after a **new kernel**, if the module is missing: `sudo dkms status` and reinstall/rebuild as needed.
6. **xrdp + XFCE:** ensure `/etc/xrdp/startwm.sh` ends with **`exec startxfce4`** (and `unset DBUS_SESSION_BUS_ADDRESS` / `XDG_RUNTIME_DIR` if needed) to avoid black-screen disconnects.
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

*Last updated: April 2026 — re-validate commands on your Ubuntu version after `do-release-upgrade`.*
