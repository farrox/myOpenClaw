# Ubuntu status — `mypc` (OpenClaw track)

**Next LLM:** start from **[LLM_RESUME_CHECKPOINT.md](LLM_RESUME_CHECKPOINT.md)** for the resume point and ordered next tasks, then use this file as the **living technical log**.

Living log of **what we verified**, **what we assumed**, and **steps taken** for OpenClaw on this household Ubuntu workstation. Update this file as install/config progresses; commit and push with meaningful messages.

**Canonical context:** [LLM_ASSISTANT_SETUP_GUIDE.md](LLM_ASSISTANT_SETUP_GUIDE.md) + [UBUNTU_WORKSTATION_NOTES.md](UBUNTU_WORKSTATION_NOTES.md). Day‑2 ops: [HOW_TO_USE.md](HOW_TO_USE.md), [SUCCESS.md](SUCCESS.md). Proton: [PROTON_PASS_SETUP.md](PROTON_PASS_SETUP.md), [QUICK_START_PROTON.md](QUICK_START_PROTON.md).

---

## Host profile (assumptions unless marked verified)

| Item | Value | Notes |
|------|--------|--------|
| Machine | `mypc` | Verified: kernel hostname in `uname` is `mypc`. |
| OS | Ubuntu 24.04.4 LTS (noble) desktop | Verified: `lsb_release -a`; kernel `6.8.0-107-generic`. |
| Primary user | `ed` | Verified under `sudo -u ed`. |
| Agent workspace | `~/clawd` | Populated from Mac via **rsync**; **`openclaw onboard`** reports **Workspace OK: ~/clawd**. |
| Repo clone | `~/Developer/myOpenClaw` | This file lives here. |
| Secrets | Proton Pass (`pass-cli`) | Binary **`~/.local/bin/pass-cli`** v1.9.0 (manual install 2026-04-05); **`pass-cli login`** still for Ed. |
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
| `~/clawd` | **Present** (`SECURITY.md`, **`TOOLS.md`**, **`SCHEDULING.md`**, **`memory/`**, etc.). |
| `~/.openclaw` | **Present** after **`openclaw onboard`**; **`openclaw.json`** updated; sessions under **`~/.openclaw/agents/main/sessions`**. |
| `openclaw` | **OpenClaw 2026.4.2** (`d74a122`) under nvm’s global bin after **`nvm.sh`** is sourced; **`command openclaw --version`** OK in that environment. Interactive SSH without loading nvm still shows **`npm`/`openclaw` not found** until **`~/.bashrc`** loads nvm (see changelog). |
| `pass-cli` | **`~/.local/bin/pass-cli`** v1.9.0; on **`PATH`** in login shell for **`ed`** |
| `gcalcli` | **`/usr/bin/gcalcli`** present |
| **`curl`** | **`/usr/bin/curl`** **8.5.0** (apt **`curl_8.5.0-2ubuntu10.8`**, installed **2026-04-05**) — Proton **`install.sh`** and docs that assume **`curl`** now work. |

---

## Progress checklist (OpenClaw)

- [x] Node.js LTS + npm; global bin on `PATH` for **login** shells (`bash -l`, SSH login, **`bash -lc`**). **Re-check** RDP/XFCE session `PATH` when you run the gateway from the GUI (may need desktop env or **`~/.xsessionrc`** if `node` is missing there).
- [x] `npm install -g openclaw`; `command openclaw --version` works (no shell wrapper deadlock). **482 packages** in ~1m; npm suggested upgrading itself to 11.x (optional).
- [x] `mkdir -p ~/clawd/memory`; `SECURITY.md`, `TOOLS.md`, `SCHEDULING.md` in `~/clawd` (rsync from Mac **`~/clawd`**).
- [x] `~/.openclaw/openclaw.json` updated via **`openclaw onboard --non-interactive --accept-risk --workspace /home/ed/clawd --auth-choice skip --mode local`** (CLI prints **Workspace OK: ~/clawd**).
- [x] Anthropic `auth-profiles.json` correct shape (`version` + `profiles.anthropic:default`); **`chmod 600`**.
- [x] `chmod 700` **`~/.openclaw`**, subdirs, **`~/.openclaw/credentials`**; JSON config files **`chmod 600`** where applicable.
- [x] **`~/.openclaw/exec-approvals.json`** — defaults **`allowlist`**, **`ask: on-miss`**, **`askFallback: deny`**, **`autoAllowSkills: false`**; agent **`main`** allowlist: **`/bin/ls`**, **`/usr/bin/find`**, **`/usr/bin/file`**, **`/usr/bin/gcalcli`**. **`openclaw.json`** → **`tools.exec`**: **`host: gateway`**, **`security: allowlist`**, **`ask: on-miss`**.
- [x] **`pass-cli`** on exec allowlist (**`openclaw approvals allowlist add --agent main "$(command -v pass-cli)"`** → pattern **`~/.local/bin/pass-cli`**).
- [x] **`openclaw security audit`**: **0 critical** · **2 warn** · **1 info** (see changelog — not “clean,” but no permission WARNs).
- [x] **Gateway process + health (automated 2026-04-05):** **`ss`** shows **`127.0.0.1:18789`** **`openclaw-gatewa`**; **`openclaw health`** OK.
- [x] **Control UI / dashboard (human 2026-04-05):** **`openclaw gateway run`** — listening **`ws://127.0.0.1:18789`**, webchat connected, RPCs (**`node.list`**, **`device.pair.list`**, **`chat.history`**, **`models.list`**) OK. **`openclaw dashboard`** opened Control UI in browser. **Do not** paste dashboard URLs (they contain **`#token=`**); treat as secret and rotate if leaked.
- [x] **`~/.openclaw/emergency_shutdown.sh`** — **`chmod 700`**, stops **`openclaw`**, strips **`check_email`** crontab lines if present, appends **`activity.log`**.

---

## Seller agent (Transfer → listings)

- [x] **`~/clawd/SELLER_AGENT_LLM_GUIDE.md`** — copied from **`~/Developer/myOpenClaw/SELLER_AGENT_LLM_GUIDE.md`**.
- [x] **`~/clawd/TOOLS.md`** — new **Seller listings** + **gcalcli** Ubuntu allowlist example.
- [x] **`~/clawd/AGENTS.md`** — session hook: read seller guide when Ed mentions Transfer / marketplaces.
- [x] **`/home/ed/Transfer/items/`** — created; **`LAYOUT.txt`** explains one-folder-per-listing.
- [x] **`~/clawd/Transfer`** → symlink to **`/home/ed/Transfer`**.

---

## Changelog / steps log

### 2026-04-05 (gateway + dashboard smoke test — Ed)

- **`openclaw gateway run`** + **`openclaw dashboard`**: gateway on **127.0.0.1:18789**, Control UI webchat connected, **`device.pair.list`** / **`chat.history`** / **`models.list`** succeeded per gateway log. Model **anthropic/claude-opus-4-6**. **Reminder:** dashboard links embed a **token** in the URL — never commit or share; regenerate if exposed.

### 2026-04-05 (`curl` via apt)

- **`sudo apt install curl`** completed (package **`curl_8.5.0-2ubuntu10.8_amd64`**). **`curl --version`** → **8.5.0** at **`/usr/bin/curl`**. Proton Pass **`install.sh`** can be used for future upgrades alongside the existing manual **1.9.0** binary.

### 2026-04-05 (TEMP_REMOTE_CLIPBOARD_HANDOFF — automated pass-cli + smoke notes)

- **`pass-cli`:** Installed **Proton Pass CLI 1.9.0** to **`/home/ed/.local/bin/pass-cli`** via **`wget`** + **`sha256sum`** against **`https://proton.me/download/pass-cli/versions.json`** (official **`install.sh`** refused: **`curl`** not installed; **`sudo apt install curl`** unavailable without interactive sudo).
- **Exec allowlist:** **`openclaw approvals allowlist add --agent main "$(command -v pass-cli)"`** — local **`exec-approvals.json`** updated.
- **`~/clawd/TOOLS.md`:** Ubuntu / manual install note added (not in git).
- **Gateway checks:** **`openclaw doctor`**, **`openclaw health`**, **`openclaw security audit --deep`** (summary unchanged: **0 critical · 2 warn · 1 info**). **`openclaw agent --agent main -m "…"`** → gateway **pairing required**, embedded path returned model text **`pong`**.
- **Seller:** **`/home/ed/Transfer/items/`** still only **`LAYOUT.txt`** — no **`<slug>`** folders with photos yet.
- **Repo:** **`TEMP_REMOTE_CLIPBOARD_HANDOFF.txt`** removed; **`ubuntu_status.md`**, **`LLM_RESUME_CHECKPOINT.md`**, **`PROTON_PASS_SETUP.md`** updated.

### 2026-04-05 (LLM handoff doc)

- Added **`LLM_RESUME_CHECKPOINT.md`** — **start here** for the next LLM on **`mypc`**; linked from **README**, **LLM_ASSISTANT_SETUP_GUIDE.md**, **SELLER_AGENT_LLM_GUIDE.md**, and this file’s header.

### 2026-04-05 (exec hardening + emergency script)

- **`exec-approvals.json`** created/updated; **`openclaw.json`** **`tools.exec`** aligned with allowlist mode.
- **`chmod 700`** on **`~/.openclaw`** tree; **`~/.openclaw/credentials`** created **`700`**.
- **`openclaw security audit`:** **0 critical**, **2 warn**, **1 info** — **`gateway.trusted_proxies_missing`** (expected if Control UI stays **loopback-only**); **`tools.exec.allowlist_interpreter_without_strict_inline_eval`** for **`/usr/bin/find`** (optional: **`tools.exec.strictInlineEval=true`** in config if you want that hardening).
- **`emergency_shutdown.sh`** added under **`~/.openclaw/`**.
- **Reminder:** if **`openclaw.json`** (gateway token) was ever copied into chat or logs, **rotate** the gateway token / treat as exposed.

### 2026-04-05 (seller agent wiring)

- See **Seller agent** checklist above (workspace + Transfer layout; not committed to git — lives under **`/home/ed/clawd`** and **`/home/ed/Transfer`**).

### 2026-04-05 (onboard)

- **`openclaw onboard --non-interactive --accept-risk`** with **`--workspace /home/ed/clawd`**, **`--auth-choice skip`**, **`--mode local`**: updated **`~/.openclaw/openclaw.json`**; **Workspace OK: ~/clawd**; **Sessions OK: ~/.openclaw/agents/main/sessions**.
- **Gateway probe:** if the CLI warns **Gateway did not become reachable** at **`ws://127.0.0.1:18789`**, that only means nothing was listening during onboard—**not** a failed workspace step. Fix: **`openclaw gateway run`** (or **`openclaw gateway install`** + **`start`**), re-onboard with **`--install-daemon`**, or use **`--skip-health`** next time.
- **Next:** Anthropic **`auth-profiles.json`** + **`chmod 600`**, **`chmod 700 ~/.openclaw`**, then **`openclaw doctor`** / **`openclaw gateway run`**.

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

*Next update: after Ed runs **`pass-cli login`** and **dashboard/tui pairing** — paste command outputs into the changelog (redact secrets). See **[LLM_RESUME_CHECKPOINT.md](LLM_RESUME_CHECKPOINT.md)**.*
