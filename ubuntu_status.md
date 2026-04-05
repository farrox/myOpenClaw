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
| Remote access | SSH + RDP (xrdp/XFCE) | See [UBUNTU_WORKSTATION_NOTES.md](UBUNTU_WORKSTATION_NOTES.md). |
| GPU | NVIDIA 470 / Kepler | Driver notes in workstation doc. |

---

## Verified on workspace environment (2026-04-05)

Commands: `sudo -u ed bash -lc '…'` (non-login, non-interactive).

| Check | Result |
|--------|--------|
| `~/clawd` | **Missing** |
| `~/.openclaw` | **Missing** |
| `node` / `npm` on `PATH` | **Not found** (may exist in login shell / nvm — **verify** `bash -ilc 'command -v node'` on mypc) |
| `openclaw` | **Not on `PATH`** |
| `pass-cli` | **Not on `PATH`** |
| `gcalcli` | **`/usr/bin/gcalcli`** present |

**Assumption:** Ed’s **interactive** desktop or login shell may load nvm/fnm/asdf or `~/.local/bin`; the table above is intentionally conservative.

---

## Progress checklist (OpenClaw)

- [ ] Node.js LTS + npm; global bin on `PATH` for sessions that will run the gateway (including RDP/XFCE if used).
- [ ] `npm install -g openclaw`; `command openclaw --version` works (no shell wrapper deadlock).
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

### 2026-04-05

- **Added** this file (`ubuntu_status.md`).
- **README.md:** linked this doc in the documentation table.
- **Git:** committed on `main` and **pushed** to `origin` (`github.com:farrox/myOpenClaw.git`).
- **Assumption:** Cursor workspace is the same machine as `mypc`; if not, re-run verification there and replace the “Verified” section.
- **Assumption:** OpenClaw install has **not** started on mypc until Node + global npm are confirmed for the intended shell profile.

---

*Next update: after Node/OpenClaw install or first `openclaw gateway` run — paste command outputs into the changelog (redact secrets).*
