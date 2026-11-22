#!/usr/bin/env bash
DEPS=(pnpm)

install() {
  if command -v pi >/dev/null; then
    log_ok "pi (already installed)"
  else
    log_info "installing pi agent..."
    pnpm add -g --ignore-scripts @earendil-works/pi-coding-agent
  fi
}

upgrade() {
  pnpm add -g --ignore-scripts @earendil-works/pi-coding-agent@latest
}
