#!/usr/bin/env bash
DEPS=(php)

BIN="$HOME/.local/bin/phpactor"

phpactor_download() {
  log_info "downloading phpactor..."
  mkdir -p "$(dirname "$BIN")"
  curl -fLo "$BIN.new" \
    "https://github.com/phpactor/phpactor/releases/latest/download/phpactor.phar"
  chmod +x "$BIN.new"
  mv "$BIN.new" "$BIN"
}

install() {
  if command -v phpactor >/dev/null; then
    log_ok "phpactor (already installed)"
  else
    phpactor_download
  fi

  symlink "$DOTS/phpactor/config" "$HOME/.config/phpactor"
}

upgrade() {
  phpactor_download
}

remove() {
  unlink_dot "$HOME/.config/phpactor"
}
