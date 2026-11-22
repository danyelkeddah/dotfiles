#!/usr/bin/env bash
# not from mise: claude's own installer keeps itself up to date

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
