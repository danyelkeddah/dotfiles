#!/usr/bin/env bash

install() {
  if command -v cargo >/dev/null; then
    log_ok "rust (already installed)"
  else
    log_info "installing rust..."
    # --no-modify-path: .zshrc already sources ~/.cargo/env
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
  fi
}

upgrade() {
  rustup update
}
