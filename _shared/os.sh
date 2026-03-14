#!/usr/bin/env bash
# _shared/os.sh


export SECRETS_FILE="$HOME/.secrets.zsh"

upsert_secret() {
  local key="$1"
  local value="$2"

  if grep -q "^export $key=" "$SECRETS_FILE"; then
    if is_macos; then
      sed -i '' "s|^export $key=.*|export $key=\"$value\"|" "$SECRETS_FILE"
    else
      sed -i "s|^export $key=.*|export $key=\"$value\"|" "$SECRETS_FILE"
    fi
    log_info "updated $key"
  else
    echo "export $key=\"$value\"" >> "$SECRETS_FILE"
    log_info "added $key"
  fi
}

remove_secret() {
  local key="$1"

  if grep -q "^export $key=" "$SECRETS_FILE"; then
    if is_macos; then
      sed -i '' "/^export $key=.*/d" "$SECRETS_FILE"
    else
      sed -i "/^export $key=.*/d" "$SECRETS_FILE"
    fi
    log_info "removed $key"
  else
    log_info "$key not found — skipping"
  fi
}

# ── Logging ───────────────────────────────────────────────────────────────────

log_header() { echo -e "\n\033[1;34m==> $1\033[0m"; }
log_ok()     { echo -e "\033[1;32m  ✓ $1\033[0m"; }
log_err()    { echo -e "\033[1;31m  ✗ $1\033[0m"; }
log_info()   { echo -e "\033[1;36m  → $1\033[0m"; }

# ── Detection ─────────────────────────────────────────────────────────────────

is_macos()  { [[ "$(uname -s)" == "Darwin" ]]; }
is_arch()   { [[ -f /etc/arch-release ]]; }
is_ubuntu() { [[ -f /etc/debian_version ]]; }

# ── Symlink ───────────────────────────────────────────────────────────────────

symlink() {
  local src="$1"
  local dest="${2/#\~/$HOME}"

  mkdir -p "$(dirname "$dest")"

  if [ -L "$dest" ]; then
    if [ "$(readlink "$dest")" = "$src" ]; then
      # correct symlink — nothing to do
      log_ok "$dest (already linked)"
      return 0
    else
      # wrong target — remove and re-symlink
      log_info "$dest points to wrong target — relinking"
      rm "$dest"
    fi
  fi

  # exists but is a real file — back it up
  [ -e "$dest" ] && [ ! -L "$dest" ] && mv "$dest" "$dest.bak"

  ln -sf "$src" "$dest"
  log_ok "linked: $dest"
}
