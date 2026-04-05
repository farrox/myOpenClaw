# Ubuntu status — `mypc` (OpenClaw track)

Living log of **what we verified**, **what we assumed**, and **steps taken** for OpenClaw on this household Ubuntu workstation. Update this file as install/config progresses; commit and push with meaningful messages.

**Canonical context:** [LLM_ASSISTANT_SETUP_GUIDE.md](LLM_ASSISTANT_SETUP_GUIDE.md) + [UBUNTU_WORKSTATION_NOTES.md](UBUNTU_WORKSTATION_NOTES.md). Day‑2 ops: [HOW_TO_USE.md](HOW_TO_USE.md), [SUCCESS.md](SUCCESS.md). Proton: [PROTON_PASS_SETUP.md](PROTON_PASS_SETUP.md), [QUICK_START_PROTON.md](QUICK_START_PROTON.md).

---

## Host profile (assumptions unless marked verified)

| Item | Value | Notes |
|------|--------|--------|
| Machine | `mypc` | Verified: kernel hostname in `uname` is `mypc`. |
| OS | Ubuntu 24.04.4 LTS (noble) desktop | Verified: `lsb_release -a`; kernel `6.8.0-107-generic`. |
| Primary user | `ed` | Verified under `sudo -u ed`. |
| Agent workspace | `~/clawd` | **Not created yet** (see below). |
| Repo clone | `~/Developer/myOpenClaw` | This file lives here. |
| Secrets | Proton Pass (`pass-cli`) | Install + PATH TBD. |
| Remote access | SSH + RDP (xrdp + Cinnamon) | See [UBUNTU_WORKSTATION_NOTES.md](UBUNTU_WORKSTATION_NOTES.md). |
| GPU | NVIDIA 470 / Kepler | Driver notes in workstation doc. |

---

## Verified on workspace environment (2026-04-05)

**Node / nvm:** Per [UBUNTU_WORKSTATION_NOTES.md](UBUNTU_WORKSTATION_NOTES.md) (nvm + Node 22 or current LTS).

| Check | Result |
|--------|--------|
| **nvm** | Installed under **`~/.nvm`** (installer **v0.40.1**); **`curl`** was missing for **`ed`**, used **`wget -qO- … \| bash`** for the install script. |
| **Node** | **`v22.22.2`** (npm **10.9.7**); **`nvm alias default 22`**. |
| **Login `PATH`** | After adding nvm load to **`~/.profile`**, **`bash -l -c 'command -v node && node -v; command -v npm && npm -v'`** succeeds (see changelog). Without **`~/.profile`** nvm init, **`bash -l -c`** did **not** see `node` because **`~/.bashrc`** returns early for non-interactive shells and never reached the nvm lines at EOF. |
| `sudo -u ed bash -lc 'command -v node && node -v; …'` | **OK** (`-l` = login → **`.profile`** runs). |
| `~/clawd` | **Missing** |
| `~/.openclaw` | **Missing** |
| `openclaw` | **OpenClaw 2026.4.2** (`d74a122`) under nvm’s global bin after **`nvm.sh`** is sourced; **`command openclaw --version`** OK in that environment. Interactive SSH without loading nvm still shows **`npm`/`openclaw` not found** until **`~/.bashrc`** loads nvm (see changelog). |
| `pass-cli` | **Not on `PATH`** yet |
| `gcalcli` | **`/usr/bin/gcalcli`** present |

**Optional:** `sudo apt install curl` so future nvm/docs that assume `curl` match this box.

---

## Progress checklist (OpenClaw)

- [x] Node.js LTS + npm; global bin on `PATH` for **login** shells (`bash -l`, SSH login, **`bash -lc`**). **Re-check** RDP/XFCE session `PATH` when you run the gateway from the GUI (may need desktop env or **`~/.xsessionrc`** if `node` is missing there).
- [x] `npm install -g openclaw`; `command openclaw --version` works (no shell wrapper deadlock). **482 packages** in ~1m; npm suggested upgrading itself to 11.x (optional).
- [ ] `mkdir -p ~/clawd/memory`; `SECURITY.md`, `TOOLS.md`, `SCHEDULING.md` in `~/clawd` (from repo templates / ACIP).
- [ ] `~/.openclaw/openclaw.json` → `agents.defaults.workspace` = `/home/ed/clawd` (or equivalent).
- [ ] Anthropic `auth-profiles.json` correct shape; `chmod 600`.
- [ ] `chmod 700` `~/.openclaw` and `~/.openclaw/credentials`.
- [ ] `exec-approvals.json` + `tools.exec` allowlist; `pass-cli` path allowlisted after install.
- [ ] `openclaw security audit` clean of permission WARNs; `openclaw approvals get` as expected.
- [ ] Gateway loopback bind; dashboard/chat smoke test.
- [ ] `~/.openclaw/emergency_shutdown.sh` aligned with any cron/email scripts.

---

## Changelog / steps log

### 2026-04-05 (OpenClaw CLI)

- **`npm install -g openclaw`** after sourcing nvm in-session: **`OpenClaw 2026.4.2 (d74a122)`** from **`command openclaw --version`**. (Harmless **`node-domexception`** deprecation warning during install.)
- **Still do:** ensure **`~/.bashrc`** ends with **`NVM_DIR` + `nvm.sh`** so new SSH shells get **`npm`/`openclaw`** without manual **`source`**.

### 2026-04-05

- **nvm + Node 22:** installed for **`ed`** (`nvm` **v0.40.1**, Node **v22.22.2**, npm **10.9.7**). Install used **`wget`** because **`curl`** was not on **`ed`**’s PATH.
- **`~/.profile`:** source **`nvm.sh`** so **`bash -l -c`** / login non-interactive shells see **`node`** / **`npm`** (aligns with [UBUNTU_WORKSTATION_NOTES.md](UBUNTU_WORKSTATION_NOTES.md) verification pattern).
- **Confirm (login environment):**
  ```text
  /home/ed/.nvm/versions/node/v22.22.2/bin/node
  v22.22.2
  /home/ed/.nvm/versions/node/v22.22.2/bin/npm
  10.9.7
  ```
  (from `sudo -u ed bash -l -c 'command -v node && node -v; command -v npm && npm -v'`.)

### 2026-04-05 (earlier)

- **Added** this file (`ubuntu_status.md`).
- **README.md:** linked this doc in the documentation table.
- **Git:** committed on `main` and **pushed** to `origin` (`github.com:farrox/myOpenClaw.git`).
- **Assumption:** Cursor workspace is the same machine as `mypc`; if not, re-run verification there and replace the “Verified” section.
- **Assumption:** OpenClaw install has **not** started on mypc until Node + global npm are confirmed for the intended shell profile.

---

*Next update: after `~/clawd` + `openclaw onboard` / first `openclaw gateway` run — paste command outputs into the changelog (redact secrets).*
