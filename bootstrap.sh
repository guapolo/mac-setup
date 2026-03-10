#!/usr/bin/env bash
# bootstrap.sh — zero to dev-ready on a brand new Mac
# Usage: ./bootstrap.sh [--profile mac-govpilot]
#
# On a fresh Mac (before git/SSH is set up):
#   1. Download this repo via HTTPS
#   2. cd ~/Dev/mac_setup && ./bootstrap.sh

set -euo pipefail

SETUP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROFILE_ARG=""

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; NC='\033[0m'

info()  { echo -e "${GREEN}[info]${NC}  $*"; }
warn()  { echo -e "${YELLOW}[warn]${NC}  $*"; }
error() { echo -e "${RED}[error]${NC} $*"; }
step()  { echo -e "\n${BOLD}${CYAN}━━━ $* ━━━${NC}"; }

while [[ $# -gt 0 ]]; do
  case "$1" in
    --profile)    PROFILE_ARG="--profile $2"; shift 2 ;;
    --profile=*)  PROFILE_ARG="--profile ${1#--profile=}"; shift ;;
    *) error "Unknown option: $1"; exit 1 ;;
  esac
done

# ── Header ────────────────────────────────────────────────────────────────────
echo ""
echo -e "${BOLD}${CYAN}"
echo "  ╔══════════════════════════════════════╗"
echo "  ║       Mac Setup — Pablo Ruiz         ║"
echo "  ╚══════════════════════════════════════╝"
echo -e "${NC}"
echo "  Setup dir: $SETUP_DIR"
echo ""

# ── macOS check ───────────────────────────────────────────────────────────────
[[ "$(uname)" == "Darwin" ]] || { error "This script is for macOS only."; exit 1; }

# ── Xcode Command Line Tools ──────────────────────────────────────────────────
step "Xcode Command Line Tools"

if xcode-select -p &>/dev/null; then
  info "Xcode CLT already installed: $(xcode-select -p)"
else
  info "Installing Xcode Command Line Tools..."
  xcode-select --install
  echo ""
  warn "A dialog has appeared to install Xcode Command Line Tools."
  warn "Please click Install and wait for it to finish, then press Enter to continue."
  read -rp "Press Enter when Xcode CLT installation is complete..."
  xcode-select -p &>/dev/null || { error "Xcode CLT installation failed."; exit 1; }
  info "Xcode CLT installed"
fi

# ── Homebrew ──────────────────────────────────────────────────────────────────
step "Homebrew"

if command -v brew &>/dev/null; then
  info "Homebrew already installed: $(brew --version | head -1)"
else
  info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Add brew to PATH for the rest of this session
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
  info "Homebrew installed"
fi

# Update before bundle install
info "Updating Homebrew..."
brew update --quiet

# ── Run install.sh ────────────────────────────────────────────────────────────
step "Running dotfile installer"

# shellcheck source=install.sh
# shellcheck disable=SC2086
bash "$SETUP_DIR/install.sh" $PROFILE_ARG

# ── Post-install manual reminders ─────────────────────────────────────────────
step "Bootstrap complete"

echo ""
echo -e "${BOLD}Automated setup is done. Manual steps remaining:${NC}"
echo ""
echo "  1Password"
echo "    - Sign in to 1Password (install: already done via brew)"
echo "    - Enable SSH agent in 1Password Settings → Developer"
echo "    - Set up SSH key for GitHub"
echo ""
echo "  SSH / GitHub"
echo "    - Generate SSH key or import from 1Password"
echo "    - Add to GitHub: https://github.com/settings/ssh/new"
echo ""
echo "  VSCode"
echo "    - Sign in with your personal account to sync extensions"
echo ""
echo "  Claude Desktop"
echo "    - Install manually from https://claude.ai/download (or uncomment cask in Brewfile)"
echo "    - Configure Claude Code settings per-machine (not managed by mac_setup)"
echo ""
echo "  API Keys"
echo "    - Fill in ~/Dev/govpilot/.envrc (Atlassian token, Linear API key)"
echo "    - Run: direnv allow ~/Dev/govpilot"
echo ""
echo "  See MANUAL_STEPS.md for full checklist."
echo ""
