# Brewfile — Mac Setup
# Run: brew bundle
# Update: brew bundle dump --force

tap "hashicorp/tap"
tap "heroku/brew"
tap "homebrew/services"

# ── Core CLI ──────────────────────────────────────────────
brew "git"
brew "gh"           # GitHub CLI
brew "vim"
brew "coreutils"    # GNU tools (gdate, gls, etc.)
brew "mas"          # Mac App Store CLI

# ── Dev environment ───────────────────────────────────────
brew "asdf"         # Language version manager
brew "direnv"       # Per-directory env vars

# ── Cloud / Infra ─────────────────────────────────────────
brew "awscli"
brew "hashicorp/tap/terraform"
brew "heroku/brew/heroku"
brew "cli53"        # Route53 CLI

# ── Databases (local dev) ─────────────────────────────────
brew "postgresql@15", restart_service: :changed, link: true
brew "redis", restart_service: :changed

# ── GUI Apps (Casks) ──────────────────────────────────────
cask "1password"
cask "1password-cli"
cask "fork"                   # Git UI
cask "google-chrome"
cask "session-manager-plugin" # AWS SSM
cask "slack"
cask "spotify"
cask "visual-studio-code"
# cask "claude"               # Claude Desktop — uncomment when cask is available

# ── VS Code Extensions ────────────────────────────────────
vscode "aliariff.vscode-erb-beautify"
vscode "anthropic.claude-code"
vscode "dline.cobaltnext"
vscode "docker.docker"
vscode "dotjoshjohnson.xml"
vscode "dqisme.sync-scroll"
vscode "eamodio.gitlens"
vscode "esbenp.prettier-vscode"
vscode "fredwangwang.vscode-hcl-format"
vscode "github.copilot-chat"
vscode "github.vscode-github-actions"
vscode "hashicorp.hcl"
vscode "hashicorp.terraform"
vscode "johnpapa.vscode-peacock"
vscode "kaiwood.endwise"
vscode "karunamurti.haml"
vscode "koichisasada.vscode-rdbg"
vscode "ldrner.rspec-snippets-vscode"
vscode "mechatroner.rainbow-csv"
vscode "ms-azuretools.vscode-docker"
vscode "ms-python.black-formatter"
vscode "ms-python.debugpy"
vscode "ms-python.python"
vscode "ms-python.vscode-pylance"
vscode "rubocop.vscode-rubocop"
vscode "shopify.ruby-extensions-pack"
vscode "shopify.ruby-lsp"
vscode "sorbet.sorbet-vscode-extension"

# ── App Store ─────────────────────────────────────────────
mas "Pixelmator Pro", id: 1289583905
