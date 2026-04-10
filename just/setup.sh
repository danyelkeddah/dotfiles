#!/usr/bin/env bash

if ! command -v just &>/dev/null; then
  log_info "installing just..."
  curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh \
    | bash -s -- --to "$HOME/.local/bin"
else
  log_info "just already installed — skipping"
fi
