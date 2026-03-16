#!/usr/bin/env bash

if ! command -v cargo &>/dev/null; then
  log_info "installing rust..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
  source "$HOME/.cargo/env"
else
  log_info "rust already installed — skipping"
fi
