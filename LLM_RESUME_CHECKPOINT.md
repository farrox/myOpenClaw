# LLM resume checkpoint — start here for the next session

**Use this file** when you are picking up work on **Ed’s OpenClaw + Ubuntu (`mypc`) + seller agent** setup. It tells you **where we left off** and **what to do next** without re-reading the whole repo.

**Rules:** [LLM_ASSISTANT_SETUP_GUIDE.md](LLM_ASSISTANT_SETUP_GUIDE.md) §0 (no secrets in git/chat, verify paths on the machine, restart gateway after `openclaw.json` / exec policy changes).

---

## Read order (efficient)

1. **This file** (`LLM_RESUME_CHECKPOINT.md`) — resume point + next tasks.
2. **[ubuntu_status.md](ubuntu_status.md)** — detailed verified state, checklists, changelog (update it as you complete steps).
3. **[UBUNTU_WORKSTATION_NOTES.md](UBUNTU_WORKSTATION_NOTES.md)** — shells, nvm, SSH/RDP, GPU, GitHub SSH.
4. **Task-specific:** [SELLER_AGENT_LLM_GUIDE.md](SELLER_AGENT_LLM_GUIDE.md) (listings), [HOW_TO_USE.md](HOW_TO_USE.md) / [SUCCESS.md](SUCCESS.md) (day‑2), [PROTON_PASS_SETUP.md](PROTON_PASS_SETUP.md) when wiring `pass-cli`.

Fresh install elsewhere? Start from [LLM_ASSISTANT_SETUP_GUIDE.md](LLM_ASSISTANT_SETUP_GUIDE.md) from the top, not this checkpoint.

---

## Environment (canonical)

| Item | Value |
|------|--------|
| Host | **`mypc`**, Ubuntu **24.04.x** (noble), user **`ed`**, home **`/home/ed`** |
| OpenClaw workspace | **`/home/ed/clawd`** (`agents.defaults.workspace` in `~/.openclaw/openclaw.json`) |
| Repo | **`/home/ed/Developer/myOpenClaw`** (this git repo) |
| Node | **nvm** + **Node 22**; **`~/.profile`** sources **`nvm.sh`** so **`bash -l -c`** sees `node`/`npm` |
| Listings inbox | **`/home/ed/Transfer`** · **`/home/ed/Transfer/items/`** · symlink **`~/clawd/Transfer`** |

**Not in git:** `~/.openclaw/`, `~/clawd/` (except what Ed copies), `/home/ed/Transfer/`. **Never commit** `openclaw.json` (gateway token), `auth-profiles.json`, or credentials.

---

## Completed (as of last checkpoint — confirm on machine)

- [x] **nvm + Node 22**; **OpenClaw** CLI installed globally via npm.
- [x] **`openclaw onboard`** with **`--workspace /home/ed/clawd`** (local mode).
- [x] **`auth-profiles.json`**: Anthropic profile shape + **`chmod 600`**.
- [x] **`chmod 700`** `~/.openclaw` tree; **`credentials/`** created **`700`**.
- [x] **`exec-approvals.json`**: defaults **allowlist** / **on-miss** / **deny** / **autoAllowSkills false**; agent **`main`** allowlist includes **`/bin/ls`**, **`/usr/bin/find`**, **`/usr/bin/file`**, **`/usr/bin/gcalcli`**.
- [x] **`openclaw.json`**: **`tools.exec`** → **`host: gateway`**, **`security: allowlist`**, **`ask: on-miss`**; **`gateway.bind`**: **loopback**.
- [x] **`openclaw security audit`**: 0 critical (2 WARN + 1 INFO documented in **ubuntu_status** changelog).
- [x] **`~/.openclaw/emergency_shutdown.sh`** (executable, owner-only).
- [x] **Seller wiring** (on disk, not in repo): **`~/clawd/SELLER_AGENT_LLM_GUIDE.md`**, **`TOOLS.md`** seller section, **`AGENTS.md`** hook, **`Transfer/items/`** + **`LAYOUT.txt`**.

---

## Next tasks (do in order — update **ubuntu_status.md** when done)

1. **Human smoke test**  
   - As **`ed`**, login shell: **`openclaw gateway`** (or `openclaw gateway run` per your install), then **`openclaw dashboard`** or **`openclaw tui`**.  
   - Confirm chat returns a real model reply.  
   - If RDP/Cinnamon session lacks `openclaw` on PATH, fix session **`PATH`** (see **UBUNTU_WORKSTATION_NOTES.md**).

2. **Proton Pass CLI (`pass-cli`)**  
   - Install per **PROTON_PASS_SETUP.md** / **QUICK_START_PROTON.md**.  
   - **`openclaw approvals allowlist add --agent main "/home/ed/.local/bin/pass-cli"`** (or **`which pass-cli`**).  
   - Document vault/commands in **`~/clawd/TOOLS.md`** if not already.

3. **Optional hardening**  
   - **`openclaw security audit --deep`** if chasing WARNs.  
   - Consider **`tools.exec.strictInlineEval=true`** if you want to address the **`find`** allowlist interpreter note (see **ubuntu_status** changelog).  
   - **`sudo apt install curl`** if you want parity with scripts that assume **`curl`**.

4. **Seller agent first run**  
   - Put photos in **`/home/ed/Transfer/items/<slug>/`**.  
   - In chat: ask OpenClaw to read **`~/clawd/SELLER_AGENT_LLM_GUIDE.md`** and draft **`listing.md`** (+ platform files).  
   - Approve any **exec** prompts for tools not yet on the allowlist.

5. **Repo hygiene**  
   - After meaningful progress, edit **`ubuntu_status.md`** changelog and **`git commit` + `git push`** from **`~/Developer/myOpenClaw`**.

---

## Quick verification commands (as user `ed`, login shell)

```bash
bash -l -c 'command -v openclaw && openclaw --version'
bash -l -c 'openclaw approvals get | head -40'
bash -l -c 'openclaw security audit'
test -f ~/clawd/SELLER_AGENT_LLM_GUIDE.md && echo seller_guide:ok
ls -la ~/clawd/Transfer /home/ed/Transfer/items 2>/dev/null | head -5
```

---

*Last checkpoint update: 2026-04-05 — align with **ubuntu_status.md** if dates diverge.*
