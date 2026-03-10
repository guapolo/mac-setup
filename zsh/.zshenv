# .zshenv — sourced for ALL shells: interactive, non-interactive, scripts, VSCode, Claude Code
# Keep this file fast and side-effect-free (no output, no prompts)

# ── Bootstrap PATH ────────────────────────────────────────────────────────────
# Ensure system dirs are present (VSCode / AI agents can start with empty PATH)
if [ -z "$PATH" ]; then
  export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
else
  for _d in /usr/local/bin /usr/bin /bin /usr/sbin /sbin; do
    case ":$PATH:" in *":$_d:"*) ;; *) PATH="$_d:$PATH" ;; esac
  done
  unset _d
  export PATH
fi

# ── Homebrew (Apple Silicon) ──────────────────────────────────────────────────
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# ── asdf version manager ──────────────────────────────────────────────────────
ASDF_DIR="${ASDF_DIR:-$HOME/.asdf}"
if [ -d "$ASDF_DIR" ]; then
  export ASDF_DIR
  export ASDF_DATA_DIR="${ASDF_DATA_DIR:-$ASDF_DIR}"
  [ -s "$ASDF_DIR/asdf.sh" ] && . "$ASDF_DIR/asdf.sh"
  # Shims ahead of system paths so asdf-managed tools win
  export PATH="$ASDF_DIR/shims:$PATH"
fi

# ── Local bin ─────────────────────────────────────────────────────────────────
export PATH="$HOME/.local/bin:$PATH"

# ── Editor ────────────────────────────────────────────────────────────────────
export EDITOR="vim"
export VISUAL="vim"

# ── Locale ────────────────────────────────────────────────────────────────────
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
