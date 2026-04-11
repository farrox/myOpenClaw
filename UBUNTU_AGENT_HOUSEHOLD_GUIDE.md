# Guide for the Ubuntu OpenClaw agent — household hosting (one admin)

**Audience:** You are the OpenClaw agent (or an LLM helping operate OpenClaw) running on **Ed’s Ubuntu machine** (`mypc`, Linux user **`ed`**).  
**Human model:** **Ed** maintains the server, installs updates, and fixes config. **Ed and his wife** each get their own *logical* assistant via **separate OpenClaw agents**—not necessarily separate Linux logins.

Read this together with **[LLM_RESUME_CHECKPOINT.md](LLM_RESUME_CHECKPOINT.md)**, **[ubuntu_status.md](ubuntu_status.md)**, and **[UBUNTU_WORKSTATION_NOTES.md](UBUNTU_WORKSTATION_NOTES.md)**. Rules in **[LLM_ASSISTANT_SETUP_GUIDE.md](LLM_ASSISTANT_SETUP_GUIDE.md)** §0 still apply (no secrets in git/chat, verify paths on disk).

---

## 1. Operating model (source of truth)

| Role | Responsibility |
|------|----------------|
| **Ed** | SSH/RDP, `apt`, Node/nvm, `openclaw` upgrades, gateway start/stop, `~/.openclaw` permissions, exec allowlists, backups, Proton/`pass-cli` when he uses it. |
| **You (agent)** | Follow workspace policies (`SECURITY.md`, `TOOLS.md`), use tools only as allowlisted, don’t claim actions you didn’t perform, escalate risky requests. |
| **Household** | Two *people*, two *OpenClaw agents* (isolated workspaces + auth + routing)—see §2. Ed is the **single OS admin** unless the family later adds a second Linux account. |

**Default assumption:** All maintenance commands run as **`ed`** on **`mypc`**. Do not assume a second Unix account exists unless Ed says so.

---

## 2. Multi-agent layout (recommended when Ed manages everything)

Use OpenClaw’s **isolated agents** (workspaces + auth + routing):

```bash
openclaw agents list
openclaw agents add          # new agent: own workspace + identity
openclaw agents set-identity  # name / theme / avatar as needed
```

Official CLI docs: [agents](https://docs.openclaw.ai/cli/agents).

**Intent:**

- **Agent A (e.g. `main`):** Ed’s workspace (e.g. **`/home/ed/clawd`**), his `auth-profiles`, his channels.
- **Agent B (e.g. a second id):** Other household member’s workspace (e.g. **`/home/ed/clawd-partner`** or a path Ed chooses), **their** `auth-profiles` and API billing where applicable, **their** messaging channels.

**Do not** merge two people’s private email, calendars, or vault material into one workspace unless Ed explicitly asks. **Do not** reuse one Anthropic profile for two humans if they need separate budgets or privacy—Ed should use separate keys or profiles per agent as he prefers.

**Gateway:** One gateway process can serve multiple agents depending on OpenClaw version and channel wiring; if Ed runs **two gateways**, they must use **different ports** and configs—never two listeners on **`18789`**. When unsure, ask Ed to run **`openclaw gateway`** / **`openclaw agents list`** and paste **non-secret** output.

---

## 3. Canonical paths on `mypc` (typical)

| Item | Path |
|------|------|
| Admin user | **`ed`**, home **`/home/ed`** |
| Repo (docs) | **`/home/ed/Developer/myOpenClaw`** |
| OpenClaw state | **`~/.openclaw/`** (never commit) |
| Ed’s workspace (example) | **`/home/ed/clawd`** |
| Second agent workspace | Whatever Ed set in **`openclaw agents add`** / config—**verify with commands**, don’t invent. |
| Seller / Transfer tree | **`/home/ed/Transfer`**; symlink **`~/clawd/Transfer`** may point here — see **[SELLER_AGENT_LLM_GUIDE.md](SELLER_AGENT_LLM_GUIDE.md)**. |
| Node | **`~/.nvm`**, default Node 22; load **`nvm.sh`** in the shell that runs CLI/gateway (see **UBUNTU_WORKSTATION_NOTES.md**). |
| `pass-cli` | Often **`~/.local/bin/pass-cli`**; GUI terminals need **`~/.local/bin`** on **`PATH`** in **`~/.bashrc`** as well as **`~/.profile`**. |

---

## 4. What you should do when Ed asks for “household” changes

1. **Confirm which agent** the change applies to (`main` vs another id).
2. **Confirm paths** with **`ls`**, **`openclaw config get`**, or **`openclaw agents list`**—no guessed home directories.
3. **After** edits to **`openclaw.json`**, exec policy, or agent config, remind Ed to **restart the gateway** if his workflow requires it.
4. **Document** non-obvious choices in **`ubuntu_status.md`** (repo) or Ed’s **`~/clawd/memory/`** when he asks for a durable log—**never** put API keys or gateway tokens there.

---

## 5. Security reminders (household scale)

- Treat **dashboard URLs** with **`#token=`** as secrets; never paste into chat or git.
- **Exec allowlist:** new binaries (e.g. spouse-specific tools) need **`openclaw approvals allowlist add --agent <id> …`** for the **correct** agent.
- **RDP vs SSH:** `PATH` may differ; if **`openclaw`** or **`pass-cli`** is “missing,” check **login vs non-login** shell and **`~/.bashrc`** (see **ubuntu_status.md** changelog).

---

## 6. Related docs

| File | Use |
|------|-----|
| [LLM_RESUME_CHECKPOINT.md](LLM_RESUME_CHECKPOINT.md) | Current done/open tasks, verify commands. |
| [ubuntu_status.md](ubuntu_status.md) | Technical log for `mypc`. |
| [UBUNTU_WORKSTATION_NOTES.md](UBUNTU_WORKSTATION_NOTES.md) | Shells, nvm, SSH, RDP, GPU. |
| [SELLER_AGENT_LLM_GUIDE.md](SELLER_AGENT_LLM_GUIDE.md) | Listing drafts from **`Transfer/`**. |
| [SUCCESS.md](SUCCESS.md) | Exec defaults, allowlist patterns. |

---

*Last updated: April 6, 2026 — Ed manages one Ubuntu admin account; multiple OpenClaw agents for household separation.*
