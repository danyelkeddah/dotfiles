#!/usr/bin/env bash
DEPS=(homebrew packages pnpm)

if ! command -v hunk &>/dev/null; then
  log_info "installing hunk..."
  pnpm add -g hunkdiff
else
  log_info "hunk already installed — skipping"
fi

log_info "symlinking hunk config..."
symlink "$DOTS/hunk/config/config.toml" "$HOME/.config/hunk/config.toml"
