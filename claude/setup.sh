#!/usr/bin/env bash

install() {
  if command -v claude >/dev/null; then
    log_ok "claude (already installed)"
  else
    log_info "installing claude code..."
    curl -fsSL https://claude.ai/install.sh | bash
  fi
}

upgrade() {
  claude update
}
