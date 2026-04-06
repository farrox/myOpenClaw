# LLM resume checkpoint — **start here** for the next session

**Use this file first** when picking up **Ed’s OpenClaw + Ubuntu (`mypc`) + seller agent** work. It gives **read order**, **`mypc` paths**, **done vs open**, **numbered next tasks**, and **quick verify commands** so you do not have to re-read the whole repo.

**Rules:** [LLM_ASSISTANT_SETUP_GUIDE.md](LLM_ASSISTANT_SETUP_GUIDE.md) §0 — no secrets in git/chat, verify paths on the machine, restart gateway after `openclaw.json` / exec policy changes.

---

## Not in git (critical)

These locations are **on disk only** on Ed’s machine; they are **not** tracked by **`~/Developer/myOpenClaw`**:

| Location | Role |
|----------|------|
| **`~/.openclaw/`** | Config, sessions, credentials, `openclaw.json` (gateway token), `exec-approvals.json`, logs. **Never commit.** |
| **`~/clawd/`** (`/home/ed/clawd`) | Agent workspace: `SECURITY.md`, `TOOLS.md`, copied guides, `memory/`, etc. Sync/rsync may mirror repo files here; **workspace edits are not automatically in git.** |
| **`/home/ed/Transfer/`** | Listing photos and per-item folders (`items/<slug>/`, `listing.md`, …). **`~/clawd/Transfer`** may symlink here. **Never commit** customer/listing content. |

Only **`~/Developer/myOpenClaw`** is the git repo unless Ed adds another clone path.

---

## Read order (efficient)

1. **This file** (`LLM_RESUME_CHECKPOINT.md`) — resume point, paths, done/open, numbered tasks, verify commands.
2. **[ubuntu_status.md](ubuntu_status.md)** — detailed verified state, checklists, changelog (**update when you finish steps**).
3. **[UBUNTU_WORKSTATION_NOTES.md](UBUNTU_WORKSTATION_NOTES.md)** — shells, nvm, SSH/RDP, GPU, GitHub SSH.
4. **Task-specific:** [SELLER_AGENT_LLM_GUIDE.md](SELLER_AGENT_LLM_GUIDE.md) (listings), [HOW_TO_USE.md](HOW_TO_USE.md) / [SUCCESS.md](SUCCESS.md) (day‑2), [PROTON_PASS_SETUP.md](PROTON_PASS_SETUP.md) when wiring `pass-cli`.

**Fresh install on another machine?** Start from [LLM_ASSISTANT_SETUP_GUIDE.md](LLM_ASSISTANT_SETUP_GUIDE.md) from the top, not this checkpoint.

---

## `mypc` paths (canonical)

| Item | Path |
|------|------|
| Host | **`mypc`**, Ubuntu **24.04.x** (noble), user **`ed`**, home **`/home/ed`** |
| **Git repo** | **`/home/ed/Developer/myOpenClaw`** |
| OpenClaw workspace | **`/home/ed/clawd`** (`agents.defaults.workspace` in `~/.openclaw/openclaw.json`) |
| OpenClaw state / secrets | **`~/.openclaw/`** |
| Node (nvm) | **`~/.nvm`**, default **Node 22**; **`~/.profile`** sources **`nvm.sh`** so **`bash -l -c`** sees `node` / `npm` / global CLIs |
| Listings inbox | **`/home/ed/Transfer`**, **`/home/ed/Transfer/items/`**; optional symlink **`~/clawd/Transfer`** → **`/home/ed/Transfer`** |

---

## Done vs open (re-verify on machine)

**Done (last documented checkpoint — confirm still true):**

- [x] **nvm + Node 22**; **OpenClaw** CLI installed globally via npm (**2026.4.2** on last log).
- [x] **`openclaw onboard`** with **`--workspace /home/ed/clawd`** (local mode).
- [x] **`auth-profiles.json`**: Anthropic profile shape + **`chmod 600`**.
- [x] **`chmod 700`** `~/.openclaw` tree; **`credentials/`** **`700`** where used.
- [x] **`exec-approvals.json`**: defaults **allowlist** / **on-miss** / **deny** / **autoAllowSkills false**; agent **`main`** allowlist includes **`/bin/ls`**, **`/usr/bin/find`**, **`/usr/bin/file`**, **`/usr/bin/gcalcli`**, **`~/.local/bin/pass-cli`** (pattern).
- [x] **`openclaw.json`**: **`tools.exec`** → **`host: gateway`**, **`security: allowlist`**, **`ask: on-miss`**; **`gateway.bind`**: **loopback**.
- [x] **`openclaw security audit`**: 0 critical (2 WARN + 1 INFO documented in **ubuntu_status** changelog).
- [x] **`~/.openclaw/emergency_shutdown.sh`** (executable, owner-only).
- [x] **Seller wiring (on disk, not in repo):** **`~/clawd/SELLER_AGENT_LLM_GUIDE.md`**, **`TOOLS.md`** seller section, **`AGENTS.md`** hook, **`Transfer/items/`** + **`LAYOUT.txt`**, **`~/clawd/Transfer`** → **`/home/ed/Transfer`**.
- [x] **`curl`** (apt) — **`/usr/bin/curl`** **8.5.0**; official Proton **`install.sh`** and other **`curl`**-based scripts work.
- [x] **Gateway + Control UI** — **`openclaw gateway run`** + **`openclaw dashboard`** verified (2026-04-05); webchat + RPCs OK. **Never** share dashboard URLs (**`#token=`**); treat as a secret.
- [x] **`pass-cli`** — Authenticated (**`pass-cli login`** reports *Already authenticated* **2026-04-05**).

**Open / still to do:**

- [ ] **Seller first listing** — No per-**`<slug>`** photo folders yet under **`Transfer/items/`** (only **`LAYOUT.txt`**); add photos then run seller workflow.
- [ ] **Optional:** **`tools.exec.strictInlineEval=true`** (addresses **`find`** allowlist WARN in audit).

---

## Next tasks (numbered — do in order; update **ubuntu_status.md** when done)

1. **Seller agent first run** — Add photos under **`/home/ed/Transfer/items/<slug>/`**, then follow **`~/clawd/SELLER_AGENT_LLM_GUIDE.md`**. Approve **exec** prompts for tools not yet on the allowlist.

2. **Optional hardening** — Consider **`tools.exec.strictInlineEval=true`** for the **`find`** allowlist interpreter note (see **ubuntu_status** changelog).

3. **Repo hygiene** — After changes, **`git commit` + `git push`** from **`~/Developer/myOpenClaw`** (no secrets).

---

## Quick verification commands (as user `ed`, **login** shell)

Use **`-l`** so **`~/.profile`** loads nvm (see **UBUNTU_WORKSTATION_NOTES.md**).

```bash
bash -l -c 'command -v openclaw && openclaw --version'
bash -l -c 'command -v node && node -v && command -v npm && npm -v'
bash -l -c 'openclaw approvals get | head -40'
bash -l -c 'openclaw security audit'
command -v curl >/dev/null && curl --version | head -1
test -f ~/clawd/SELLER_AGENT_LLM_GUIDE.md && echo seller_guide:ok
test -L ~/clawd/Transfer -o -d ~/clawd/Transfer && echo clawd_transfer:ok
ls -la ~/clawd/Transfer /home/ed/Transfer/items 2>/dev/null | head -8
command -v pass-cli >/dev/null && echo pass_cli:ok || echo pass_cli:missing
```

---

*Last checkpoint update: 2026-04-05 (**pass-cli** authenticated; next: **seller photos** under **`Transfer/items/`**) — align with **ubuntu_status.md** if dates or checkboxes diverge.*
