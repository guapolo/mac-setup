#!/usr/bin/env bash
# macos/defaults.sh — sensible macOS defaults for a dev machine
# Run standalone: bash macos/defaults.sh
# Called automatically by install.sh

set -euo pipefail

echo "[macos] Applying macOS defaults..."

# ── Screenshots ───────────────────────────────────────────────────────────────
mkdir -p "$HOME/Screenshots"
defaults write com.apple.screencapture location "$HOME/Screenshots"
defaults write com.apple.screencapture type png
defaults write com.apple.screencapture disable-shadow -bool true
echo "[macos]   Screenshots → ~/Screenshots"

# ── Safari developer tools ────────────────────────────────────────────────────
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" -bool true
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true
echo "[macos]   Safari developer tools enabled"

# ── Finder ────────────────────────────────────────────────────────────────────
defaults write com.apple.finder ShowPathbar -bool true        # Show path bar
defaults write com.apple.finder ShowStatusBar -bool true       # Show status bar
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"  # List view default
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true   # Full path in title
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"  # Search current folder
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false  # Save to disk, not iCloud
echo "[macos]   Finder configured"

# ── Dock ─────────────────────────────────────────────────────────────────────
defaults write com.apple.dock autohide -bool true              # Auto-hide dock
defaults write com.apple.dock autohide-delay -float 0          # No delay on show
defaults write com.apple.dock show-recents -bool false         # No recent apps
echo "[macos]   Dock configured"

# ── Keyboard ──────────────────────────────────────────────────────────────────
defaults write NSGlobalDomain KeyRepeat -int 2                 # Fast key repeat
defaults write NSGlobalDomain InitialKeyRepeat -int 15         # Short initial delay
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false  # No accent popup
echo "[macos]   Keyboard configured"

# ── Trackpad ──────────────────────────────────────────────────────────────────
defaults write NSGlobalDomain com.apple.trackpad.scaling -float 2.5  # Faster tracking
echo "[macos]   Trackpad configured"

# ── Menu bar clock ────────────────────────────────────────────────────────────
defaults write com.apple.menuextra.clock ShowSeconds -bool false
defaults write com.apple.menuextra.clock DateFormat -string "EEE d MMM  HH:mm"
echo "[macos]   Clock configured"

# ── Privacy / Telemetry ───────────────────────────────────────────────────────
defaults write com.apple.CrashReporter DialogType -string "none"
echo "[macos]   Crash reporter silenced"

# Restart affected apps
for app in "Finder" "Dock" "SystemUIServer" "cfprefsd"; do
  killall "$app" &>/dev/null || true
done

echo "[macos] Done. Some changes require a logout/restart to take effect."
