#!/usr/bin/env bash
# install.sh — idempotent dotfile installer, safe to re-run
# Usage: ./install.sh [--profile mac-govpilot] [--dry-run]

set -euo pipefail

SETUP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
DRY_RUN=false
PROFILE=""

# ── Colors ────────────────────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; CYAN='\033[0;36m'; BOLD='\033[1m'; NC='\033[0m'

info()  { echo -e "${GREEN}[info]${NC}  $*"; }
warn()  { echo -e "${YELLOW}[warn]${NC}  $*"; }
error() { echo -e "${RED}[error]${NC} $*"; }
step()  { echo -e "\n${BOLD}${CYAN}▸ $*${NC}"; }
dry()   { echo -e "${BLUE}[dry]${NC}   $*"; }

# ── Helpers ───────────────────────────────────────────────────────────────────
backup_and_copy() {
  local src="$1" dest="$2" label="${3:-$dest}"
  if [[ "$DRY_RUN" == true ]]; then
    dry "Would install: $src → $dest"
    return
  fi
  if [[ -e "$dest" || -L "$dest" ]]; then
    mkdir -p "$BACKUP_DIR"
    cp -P "$dest" "$BACKUP_DIR/$(basename "$dest")"
  fi
  mkdir -p "$(dirname "$dest")"
  cp "$src" "$dest"
  info "Installed $label"
}

run() {
  if [[ "$DRY_RUN" == true ]]; then
    dry "Would run: $*"
  else
    "$@"
  fi
}

cmd_exists() { command -v "$1" &>/dev/null; }

# ── Arg parsing ───────────────────────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)    DRY_RUN=true; shift ;;
    --profile)    PROFILE="$2"; shift 2 ;;
    --profile=*)  PROFILE="${1#--profile=}"; shift ;;
    -h|--help)
      echo "Usage: $0 [--profile NAME] [--dry-run]"
      echo "Profiles: $(ls "$SETUP_DIR/profiles/"*.sh 2>/dev/null | xargs -n1 basename | grep -v '^_' | sed 's/\.sh//' | tr '\n' ' ')"
      exit 0 ;;
    *) error "Unknown option: $1"; exit 1 ;;
  esac
done

# ── Load profile ──────────────────────────────────────────────────────────────
step "Loading machine profile"

if [[ -z "$PROFILE" ]]; then
  available=($(ls "$SETUP_DIR/profiles/"*.sh 2>/dev/null | xargs -n1 basename | grep -v '^_' | sed 's/\.sh//'))
  if [[ ${#available[@]} -eq 1 ]]; then
    PROFILE="${available[0]}"
    info "Using profile: $PROFILE"
  else
    echo "Available profiles:"
    for p in "${available[@]}"; do echo "  - $p"; done
    read -rp "Profile name: " PROFILE
  fi
fi

PROFILE_FILE="$SETUP_DIR/profiles/${PROFILE}.sh"
[[ -f "$PROFILE_FILE" ]] || { error "Profile not found: $PROFILE_FILE"; exit 1; }
# shellcheck source=/dev/null
source "$PROFILE_FILE"
info "Profile: $MACHINE_NAME | Git: $GIT_EMAIL | Workspaces: $WORKSPACES"

[[ "$DRY_RUN" == true ]] && warn "DRY RUN — no changes will be made\n"

# ── Dev directory structure ───────────────────────────────────────────────────
step "Creating ~/Dev workspace directories"

for ws in $WORKSPACES; do
  dir="$HOME/Dev/$ws"
  if [[ ! -d "$dir" ]]; then
    run mkdir -p "$dir"
    info "Created $dir"
  else
    info "$dir already exists"
  fi

  # Remove any orphaned workspace-level .planning directories
  if [[ -d "$dir/.planning" ]]; then
    warn "Removing workspace-level .planning dir: $dir/.planning"
    run rm -rf "$dir/.planning"
  fi
done

# Screenshots directory
if [[ ! -d "$HOME/Screenshots" ]]; then
  run mkdir -p "$HOME/Screenshots"
  info "Created ~/Screenshots"
fi

# ── Homebrew bundle ───────────────────────────────────────────────────────────
step "Installing Homebrew packages"

if cmd_exists brew; then
  if [[ "$DRY_RUN" == true ]]; then
    dry "Would run: brew bundle --file=$SETUP_DIR/Brewfile"
  else
    brew bundle --file="$SETUP_DIR/Brewfile" --no-lock || warn "Some packages failed — check output above"
  fi
else
  error "Homebrew not found — run bootstrap.sh first"
  exit 1
fi

# ── Oh My Zsh ─────────────────────────────────────────────────────────────────
step "Oh My Zsh"

if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  info "Installing Oh My Zsh..."
  if [[ "$DRY_RUN" == false ]]; then
    RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  else
    dry "Would install Oh My Zsh"
  fi
else
  info "Oh My Zsh already installed"
fi

# Powerlevel10k theme
P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [[ ! -d "$P10K_DIR" ]]; then
  info "Installing Powerlevel10k..."
  run git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
else
  info "Powerlevel10k already installed"
fi

# ── Dotfiles ──────────────────────────────────────────────────────────────────
step "Installing dotfiles"

backup_and_copy "$SETUP_DIR/zsh/.zshenv"  "$HOME/.zshenv"  ".zshenv"
backup_and_copy "$SETUP_DIR/zsh/.zshrc"   "$HOME/.zshrc"   ".zshrc"

# p10k config — copy from repo if present, otherwise note manual step
if [[ -f "$SETUP_DIR/zsh/.p10k.zsh" ]]; then
  backup_and_copy "$SETUP_DIR/zsh/.p10k.zsh" "$HOME/.p10k.zsh" ".p10k.zsh"
else
  warn ".p10k.zsh not in repo — run 'p10k configure' or copy from another machine"
  warn "  cp ~/.p10k.zsh $SETUP_DIR/zsh/.p10k.zsh  (on the source machine)"
fi

# ── Git configuration ─────────────────────────────────────────────────────────
step "Installing git configuration"

backup_and_copy "$SETUP_DIR/git/.gitconfig"        "$HOME/.gitconfig"        ".gitconfig"
backup_and_copy "$SETUP_DIR/git/.gitignore_global" "$HOME/.gitignore_global" ".gitignore_global"

for ws in $WORKSPACES; do
  src="$SETUP_DIR/git/.gitconfig-${ws}"
  dest="$HOME/Dev/${ws}/.gitconfig-${ws}"
  if [[ -f "$src" ]]; then
    backup_and_copy "$src" "$dest" ".gitconfig-$ws"
  fi
done

# ── asdf ─────────────────────────────────────────────────────────────────────
step "Configuring asdf"

backup_and_copy "$SETUP_DIR/asdf/.asdfrc"       "$HOME/.asdfrc"        ".asdfrc"
backup_and_copy "$SETUP_DIR/asdf/.tool-versions" "$HOME/.tool-versions" ".tool-versions (global)"

if cmd_exists asdf; then
  for plugin in ruby python nodejs rust; do
    if asdf plugin list 2>/dev/null | grep -q "^${plugin}$"; then
      info "asdf plugin $plugin already installed"
    else
      info "Installing asdf plugin: $plugin"
      run asdf plugin add "$plugin" || warn "Failed to add asdf plugin: $plugin"
    fi
  done

  info "Installing language versions from .tool-versions..."
  run asdf install || warn "Some asdf installs failed — check above"
else
  warn "asdf not found — skipping plugin setup"
fi

# ── direnv .envrc files ───────────────────────────────────────────────────────
step "Installing workspace .envrc files"

for ws in $WORKSPACES; do
  dir="$HOME/Dev/$ws"
  dest="$dir/.envrc"
  src="$SETUP_DIR/envrc-templates/${ws}.envrc"

  if [[ ! -f "$src" ]]; then
    warn "No envrc template for $ws — skipping"
    continue
  fi

  if [[ -f "$dest" ]]; then
    info "$ws/.envrc already exists — skipping (review manually: $dest)"
  else
    backup_and_copy "$src" "$dest" "$ws/.envrc"
    if [[ "$DRY_RUN" == false ]] && cmd_exists direnv; then
      (cd "$dir" && direnv allow 2>/dev/null || true)
      info "direnv allow → $dir"
    fi
  fi
done

# ── VSCode settings ───────────────────────────────────────────────────────────
step "Installing VSCode settings"

VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"
if [[ -d "$VSCODE_USER_DIR" ]] || cmd_exists code; then
  run mkdir -p "$VSCODE_USER_DIR"
  backup_and_copy "$SETUP_DIR/vscode/settings.json" "$VSCODE_USER_DIR/settings.json" "VSCode settings.json"
else
  warn "VSCode not found — settings will be installed next time"
fi

# ── macOS defaults ────────────────────────────────────────────────────────────
step "Applying macOS defaults"
run bash "$SETUP_DIR/macos/defaults.sh"

# ── App Store (mas) ───────────────────────────────────────────────────────────
if [[ "${SKIP_MAS:-false}" == false ]]; then
  step "App Store installs"
  if cmd_exists mas; then
    if mas account &>/dev/null; then
      info "Installing Pixelmator Pro..."
      run mas install 1289583905 || warn "Pixelmator Pro install failed (may already be installed)"
    else
      warn "Not signed into App Store — skipping mas installs"
      warn "  Sign in, then run: mas install 1289583905  (Pixelmator Pro)"
    fi
  else
    warn "mas not installed — skipping App Store installs"
  fi
fi

# ── Summary ───────────────────────────────────────────────────────────────────
echo ""
echo -e "${BOLD}${GREEN}════════════════════════════════════════${NC}"
echo -e "${BOLD}${GREEN}  Installation complete: $MACHINE_NAME${NC}"
echo -e "${BOLD}${GREEN}════════════════════════════════════════${NC}"
[[ -d "$BACKUP_DIR" ]] && echo -e "${YELLOW}  Backups: $BACKUP_DIR${NC}"
echo ""
echo -e "${BOLD}Next steps:${NC}"
echo "  1. Restart terminal (or: source ~/.zshenv && source ~/.zshrc)"
echo "  2. Sign into VSCode with your personal account to sync extensions/settings"
echo "  3. Fill in API tokens in ~/Dev/govpilot/.envrc (Atlassian, Linear)"
echo "  4. See MANUAL_STEPS.md for anything that needs manual attention"
[[ ! -f "$SETUP_DIR/zsh/.p10k.zsh" ]] && echo "  5. Run 'p10k configure' to set up your prompt"
echo ""
