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
