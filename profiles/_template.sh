# Machine profile template — copy and rename for each machine
# Usage: cp profiles/_template.sh profiles/mac-YOURNAME.sh

# Machine identifier (used in backup dir names and logs)
MACHINE_NAME="mac-YOURNAME"

# Primary git identity (default when not in a workspace dir)
GIT_NAME="Pablo Ruiz"
GIT_EMAIL="pruiz@govpilot.com"   # Change to primary email for this machine

# Workspaces to scaffold under ~/Dev/
# Space-separated list — each gets: directory, gitconfig, envrc, direnv allow
WORKSPACES="pjra gup govpilot"

# Set to "true" to skip App Store installs (requires signed-in App Store account)
SKIP_MAS=false

# ── SSH keys in 1Password ─────────────────────────────────────────────────────
# Format: "ITEM_NAME:account-shorthand[:vault-name]"
# account-shorthand matches the subdomain in your 1password.com URL (e.g. "ruixes" for ruixes.1password.com)
# vault-name is optional — only needed if the item name is ambiguous across vaults
SSH_KEY_PERSONAL="PR:ruixes:Private"   # → ~/.ssh/github_personal.pub
SSH_KEY_GUP="TRJ:gatherup"            # → ~/.ssh/github_gup.pub
SSH_KEY_GOVPILOT="SDL:ruixes"         # → ~/.ssh/github_govpilot.pub
