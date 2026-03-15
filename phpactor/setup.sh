#!/usr/bin/env
DEPS=(homebrew php)

if ! command -v phpactor &>/dev/null; then
  log_info "downloading phpactor..."
  curl -fLo /tmp/phpactor.phar \
    "https://github.com/phpactor/phpactor/releases/latest/download/phpactor.phar"
  chmod +x /tmp/phpactor.phar
  mkdir -p "$HOME/.local/bin"
  mv /tmp/phpactor.phar "$HOME/.local/bin/phpactor"
  log_ok "phpactor installed"
else
  log_info "phpactor already installed — skipping"
fi

log_info "symlinking phpactor config..."
symlink "$DOTS/phpactor/config" "$HOME/.config/phpactor"
