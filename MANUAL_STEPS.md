# Manual Steps

Things that can't be fully automated. Work through this list after running `bootstrap.sh`.

## 1Password
- [ ] Sign in to 1Password app
- [ ] Enable SSH agent: Settings → Developer → Use the SSH agent
- [ ] Enable CLI integration: Settings → Developer → Integrate with 1Password CLI
- [ ] Authenticate CLI: `op signin`

## SSH & GitHub
`install.sh` handles automatically:
- Installs `~/.ssh/config` (1Password agent + per-account GitHub host aliases)
- Exports SSH public keys from 1Password via `op` CLI → `~/.ssh/github_*.pub`

**Requires:** sign into all three 1Password accounts before running install:
```bash
op signin --account ruixes    # personal
op signin --account gatherup  # gup
# govpilot keys are also stored in ruixes account
```

After install, add each key to the corresponding GitHub account (one-time, per key):
- [ ] `~/.ssh/github_personal.pub` → https://github.com/settings/ssh/new (guapolo account)
- [ ] `~/.ssh/github_gup.pub` → GitHub (pablo-gus / gup account)
- [ ] `~/.ssh/github_govpilot.pub` → GitHub (p-ruiz-ab / govpilot account)

Verify:
```bash
ssh -T git@github-personal   # Hi guapolo!
ssh -T git@github-gup        # Hi pablo-gus!
ssh -T git@github-govpilot   # Hi p-ruiz-ab!
```

## Claude Desktop
The `claude` cask may not yet be available. If `brew bundle` skipped it:
- [ ] Download from https://claude.ai/download and install manually
- [ ] Claude Code settings (`~/.claude/settings.json`) are intentionally **not** managed
      by mac_setup — configure per-machine after install

## VSCode
- [ ] Sign in with personal Google/GitHub account to sync extensions and settings

## API Keys (fill into workspace .envrc files)
- [ ] `~/Dev/govpilot/.envrc` — Atlassian token, Linear API key
  - Atlassian: https://id.atlassian.com/manage-profile/security/api-tokens
  - Linear: https://linear.app/settings/api
- [ ] Run `direnv allow ~/Dev/govpilot` after editing

## p10k prompt
If `.p10k.zsh` wasn't restored from the repo:
- [ ] Run `p10k configure` to set up prompt, OR
- [ ] Copy from another machine: `cp ~/.p10k.zsh ~/Dev/mac_setup/zsh/.p10k.zsh`
      (then commit it so it's available on future machines)

## Docker Desktop
Docker Desktop is not in the Brewfile (it's large and often managed separately).
- [ ] Download from https://www.docker.com/products/docker-desktop/ if needed
- [ ] After install, Docker CLI completions will auto-add to `.zshrc` — you can
      remove the auto-added block since our `.zshrc` has a commented-out version

## Repositories
Check out the repos you need into the correct workspace directories:
```bash
# Personal
cd ~/Dev/pjra && git clone git@github.com:guapolo/dotfiles.git

# GatherUp
cd ~/Dev/gup && git clone git@github.com:...

# Govpilot
cd ~/Dev/govpilot && git clone git@github.com:...
```

## App Store
If `mas` couldn't install (not signed into App Store during setup):
- [ ] Pixelmator Pro: `mas install 1289583905`

## After first login, verify
```bash
# Git identities
cd ~/Dev/pjra   && git config user.email   # → pjruiz@gmail.com
cd ~/Dev/gup    && git config user.email   # → pablo@gatherup.com
cd ~/Dev/govpilot && git config user.email # → pruiz@govpilot.com

# asdf
asdf current

# direnv
cd ~/Dev/govpilot && echo $ATLASSIAN_EMAIL  # → pruiz@govpilot.com
```
