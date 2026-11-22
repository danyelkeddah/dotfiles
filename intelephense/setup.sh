#!/usr/bin/env bash
# only the licence key lives here; the language server itself is not installed
# by this package

LICENCE="$HOME/.config/intelephense/licence.txt"

install() {
  :
}

sync_secrets() {
  if [ -f "$LICENCE" ]; then
    log_ok "intelephense licence (already there)"
    return 0
  fi

  local key
  log_info "syncing intelephense licence from 1Password..."
  # read first: if 1Password fails, stop here rather than leave an empty file
  key="$(op read "op://Personal/Intelephense/license key")"
  mkdir -p "$(dirname "$LICENCE")"
  printf '%s\n' "$key" > "$LICENCE"
}

remove_secrets() {
  rm -f "$LICENCE"
  log_ok "intelephense licence removed"
}
