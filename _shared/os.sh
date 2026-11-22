#!/usr/bin/env bash
# _shared/os.sh


export SECRETS_FILE="$HOME/.secrets.zsh"

# upsert_secret <KEY> <value> — add or replace `export KEY="value"`
upsert_secret() {
  local key="$1" value="$2" action=added

  if grep -q "^export $key=" "$SECRETS_FILE"; then
    action=updated
    drop_secret_line "$key"
  fi
  echo "export $key=\"$value\"" >> "$SECRETS_FILE"
  log_ok "$action $key"
}

# remove_secret <KEY>
remove_secret() {
  local key="$1"

  if grep -q "^export $key=" "$SECRETS_FILE"; then
    drop_secret_line "$key"
    log_ok "removed $key"
  else
    log_info "$key not found — skipping"
  fi
}

# rewrite the file without KEY's line. Done with grep rather than `sed -i`,
# whose syntax differs between macOS and Linux and which breaks on values
# containing its delimiter. `cat >` keeps the file's permissions.
drop_secret_line() {
  local rest
  rest="$(grep -v "^export $1=" "$SECRETS_FILE" || true)"
  if [ -n "$rest" ]; then
    printf '%s\n' "$rest" > "$SECRETS_FILE"
  else
    : > "$SECRETS_FILE"
  fi
}

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

# unlink_dot <path> — undo a symlink() call.
# Only removes a symlink that points into this repo. Real files, and links to
# anywhere else, are left alone. If symlink() moved an existing file aside as
# <path>.bak, that file is put back.
unlink_dot() {
  local dest="${1/#\~/$HOME}"
  local target

  if [ ! -L "$dest" ]; then
    if [ -e "$dest" ]; then
      log_warn "$dest is a real file, not a link — left alone"
    else
      log_info "$dest not there — skipping"
    fi
    return 0
  fi

  target="$(readlink "$dest")"
  case "$target" in
    "$DOTS"/*) ;;
    *)
      log_warn "$dest points outside the dotfiles ($target) — left alone"
      return 0
      ;;
  esac

  rm "$dest"
  log_ok "unlinked: $dest"

  if [ -e "$dest.bak" ]; then
    mv "$dest.bak" "$dest"
    log_ok "restored: $dest"
  fi
}
