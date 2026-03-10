# mac_setup

One-command Mac dev environment for Pablo Ruiz.

## New machine

```bash
# 1. Sign into 1Password CLI (needed to export SSH keys during install)
op signin --account ruixes    # personal + govpilot keys live here
op signin --account gatherup  # gup/TRJ key lives here

# 2. Clone this repo (HTTPS — SSH isn't set up yet on a fresh Mac)
mkdir -p ~/Dev && git clone https://github.com/guapolo/mac-setup.git ~/Dev/mac_setup

# 3. Run bootstrap (Xcode CLT → Homebrew → install)
~/Dev/mac_setup/bootstrap.sh --profile mac-govpilot
```

After bootstrap, work through [MANUAL_STEPS.md](MANUAL_STEPS.md) — mainly adding
the exported SSH public keys to each GitHub account (one-time, per key).

## Refresh existing machine

```bash
cd ~/Dev/mac_setup && git pull
./install.sh --profile mac-govpilot
```

Safe to re-run — always backs up existing files before overwriting.

## Adding a new machine profile

```bash
cp profiles/_template.sh profiles/mac-YOURNAME.sh
# edit: MACHINE_NAME, GIT_EMAIL, SSH_KEY_* 1Password references
./install.sh --profile mac-YOURNAME
```

## How it works

### Per-workspace git identity + SSH key

Each `~/Dev/<workspace>/` gets a gitconfig with two things:
- The correct email for that workspace
- A `url.insteadOf` rule that rewrites `git@github.com:` to a workspace-specific
  SSH host alias (`github-personal`, `github-gup`, `github-govpilot`)

`~/.ssh/config` maps each alias to `github.com` with `IdentityFile` pointing to the
matching public key, which the 1Password SSH agent uses to sign with the right private key.

Result: `git push` inside any `~/Dev/` workspace automatically uses the correct
GitHub account — no manual remote URL changes ever needed.

### 1Password SSH key export

`install.sh` calls `op item get` to pull each public key from 1Password and write it
to `~/.ssh/github_<workspace>.pub`. Key item names are declared in the machine profile:

```bash
SSH_KEY_PERSONAL="PR:ruixes:Private"   # → ~/.ssh/github_personal.pub
SSH_KEY_GUP="TRJ:gatherup"            # → ~/.ssh/github_gup.pub
SSH_KEY_GOVPILOT="SDL:ruixes"         # → ~/.ssh/github_govpilot.pub
```

## Structure

```
mac_setup/
├── bootstrap.sh          # New Mac entry point: Xcode CLT → Homebrew → install
├── install.sh            # Dotfile installer, idempotent, safe to re-run
├── Brewfile              # All packages, casks, VS Code extensions, App Store
├── MANUAL_STEPS.md       # Checklist for what can't be automated
│
├── profiles/
│   ├── _template.sh      # Copy this for each new machine
│   └── mac-govpilot.sh   # Work Mac (Govpilot) — identities + 1Password key refs
│
├── zsh/
│   ├── .zshenv           # ALL shells: PATH bootstrap, Homebrew, asdf, editor
│   ├── .zshrc            # Interactive only: OMZ, P10k, direnv hook
│   └── .p10k.zsh         # Powerlevel10k prompt config
│
├── git/
│   ├── .gitconfig            # Main config — includeIf per workspace dir
│   ├── .gitconfig-pjra       # pjruiz@gmail.com + github-personal alias
│   ├── .gitconfig-gup        # pablo@gatherup.com + github-gup alias
│   ├── .gitconfig-govpilot   # pruiz@govpilot.com + github-govpilot alias
│   └── .gitignore_global
│
├── ssh/
│   └── config            # 1Password agent + github-* host aliases per account
│
├── asdf/
│   ├── .tool-versions    # Global: ruby, python, nodejs, rust
│   └── .asdfrc
│
├── envrc-templates/
│   ├── pjra.envrc        # ~/Dev/pjra — personal
│   ├── gup.envrc         # ~/Dev/gup  — GatherUp
│   └── govpilot.envrc    # ~/Dev/govpilot — Govpilot (fill in API tokens after install)
│
├── vscode/
│   └── settings.json     # Shared settings — extensions sync via personal account
│
└── macos/
    └── defaults.sh       # Screenshots → ~/Screenshots, Safari dev tools, Finder, Dock
```

## Workspace layout

```
~/Dev/
├── pjra/                 # Personal (pjruiz@gmail.com / guapolo)
│   ├── .gitconfig-pjra
│   └── .envrc
├── gup/                  # GatherUp (pablo@gatherup.com, aliases @bytraject.com @grade.us)
│   ├── .gitconfig-gup
│   └── .envrc
└── govpilot/             # Govpilot (pruiz@govpilot.com, alias pruiz@getsdl.com)
    ├── .gitconfig-govpilot
    └── .envrc            # ← fill in ATLASSIAN_API_TOKEN and LINEAR_API_KEY after install
```

## What stays per-machine (not managed by this repo)

- `~/.claude/settings.json` — Claude Code settings differ per machine
- `~/Dev/govpilot/.envrc` secret values — never commit API tokens
- SSH private keys — stay in 1Password, never touch the filesystem
