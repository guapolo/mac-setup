# .zshrc — interactive shells only
# Environment (PATH, tools) is in .zshenv — nothing duplicated here

# ── Powerlevel10k instant prompt (must be near top) ───────────────────────────
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ── Oh My Zsh ─────────────────────────────────────────────────────────────────
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git asdf aws)
source "$ZSH/oh-my-zsh.sh"

# ── Powerlevel10k config ───────────────────────────────────────────────────────
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# ── direnv (must be after Oh My Zsh) ──────────────────────────────────────────
eval "$(direnv hook zsh)"

# ── VSCode shell integration ───────────────────────────────────────────────────
if [[ "$TERM_PROGRAM" == "vscode" ]]; then
  . "$(code --locate-shell-integration-path zsh)" 2>/dev/null || true
fi

# ── Docker CLI completions (added by Docker Desktop — uncomment if needed) ─────
# fpath=($HOME/.docker/completions $fpath)
# autoload -Uz compinit && compinit
