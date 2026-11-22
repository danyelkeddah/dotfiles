#!/usr/bin/env bash

BIN="$HOME/.local/bin"

# just_installer [--force] — the official installer, into ~/.local/bin
just_installer() {
  mkdir -p "$BIN"
  curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh \
    | bash -s -- "$@" --to "$BIN"
}

install() {
  if command -v just >/dev/null; then
    log_ok "just (already installed)"
  else
    log_info "installing just..."
    just_installer
  fi
}

upgrade() {
  # only the copy this package installed; a system one is upgraded by the system
  [ -x "$BIN/just" ] || return 0
  log_info "updating just..."
  just_installer --force
}
