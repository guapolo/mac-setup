# Manual Steps

Things that can't be fully automated. Work through this list after running `bootstrap.sh`.

## 1Password
- [ ] Sign in to 1Password app
- [ ] Enable SSH agent: Settings → Developer → Use the SSH agent
- [ ] Enable CLI integration: Settings → Developer → Integrate with 1Password CLI
- [ ] Authenticate CLI: `op signin`

## SSH & GitHub
- [ ] `~/.ssh/config` is installed automatically (routes SSH auth through 1Password agent)
- [ ] Enable SSH agent in 1Password: Settings → Developer → Use the SSH agent
- [ ] Create or import SSH key in 1Password, then authorize it for GitHub
- [ ] Add SSH key to GitHub: https://github.com/settings/ssh/new
- [ ] Test: `ssh -T git@github.com`

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
