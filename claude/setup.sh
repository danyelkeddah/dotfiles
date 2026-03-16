#!/usr/bin/env bash

DEPS=(homebrew packages)

if ! command -v claude &>/dev/null; then
  log_info "installing claude code..."
  curl -fsSL https://claude.ai/install.sh | bash
else
  log_info "claude already installed — skipping"
fi
