# mac_setup

One-command Mac dev environment for Pablo Ruiz.

## New machine

```bash
# 1. Clone this repo (HTTPS — SSH not set up yet on a new Mac)
mkdir -p ~/Dev && cd ~/Dev
git clone https://github.com/guapolo/mac-setup.git mac_setup

# 2. Run bootstrap
cd mac_setup
./bootstrap.sh --profile mac-govpilot
```

That's it. See [MANUAL_STEPS.md](MANUAL_STEPS.md) for the handful of things that can't be automated (1Password sign-in, SSH keys, API tokens).

## Refresh existing machine

```bash
cd ~/Dev/mac_setup && git pull
./install.sh --profile mac-govpilot
```

Safe to re-run — always backs up before overwriting.

## Adding a new machine profile

```bash
cp profiles/_template.sh profiles/mac-YOURNAME.sh
# edit it, then:
./install.sh --profile mac-YOURNAME
```

## Structure

```
mac_setup/
├── bootstrap.sh          # New Mac entry point (Xcode → Homebrew → install)
├── install.sh            # Dotfile installer, safe to re-run
├── Brewfile              # All packages, casks, VS Code extensions
├── MANUAL_STEPS.md       # Checklist for what can't be automated
│
├── profiles/
│   ├── _template.sh      # Copy this for each new machine
│   └── mac-govpilot.sh   # Work Mac
│
├── zsh/
│   ├── .zshenv           # Loaded for ALL shells (PATH, Homebrew, asdf, editor)
│   ├── .zshrc            # Interactive shells only (OMZ, P10k, direnv)
│   └── .p10k.zsh         # Powerlevel10k config (copy from existing machine)
│
├── git/
│   ├── .gitconfig          # Main config with workspace includeIfs
│   ├── .gitconfig-pjra     # pjruiz@gmail.com
│   ├── .gitconfig-gup      # pablo@gatherup.com
│   ├── .gitconfig-govpilot # pruiz@govpilot.com
│   └── .gitignore_global
│
├── asdf/
│   ├── .tool-versions    # Global language versions
│   └── .asdfrc
│
├── envrc-templates/
│   ├── pjra.envrc        # ~/Dev/pjra — personal
│   ├── gup.envrc         # ~/Dev/gup  — GatherUp
│   └── govpilot.envrc    # ~/Dev/govpilot — Govpilot (fill in API tokens)
│
├── vscode/
│   └── settings.json
│
└── macos/
    └── defaults.sh       # Screenshots, Safari dev tools, Finder, Dock, etc.
```

## Workspace layout

```
~/Dev/
├── pjra/                 # Personal projects (pjruiz@gmail.com)
│   ├── .gitconfig-pjra
│   └── .envrc
├── gup/                  # GatherUp (pablo@gatherup.com, aliases @bytraject @grade.us)
│   ├── .gitconfig-gup
│   └── .envrc
└── govpilot/             # Govpilot/SDL (pruiz@govpilot.com, alias @getsdl.com)
    ├── .gitconfig-govpilot
    └── .envrc            # ← fill in Atlassian + Linear tokens
```

## What stays per-machine (not in this repo)

- `~/.claude/settings.json` — Claude Code settings differ per machine
- `~/Dev/govpilot/.envrc` tokens — secret values, never commit
- SSH keys — managed via 1Password
