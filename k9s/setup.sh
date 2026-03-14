#!/usr/bin/env bash
DEPS=(homebrew)

if is_macos; then
  if ! command -v k9s &>/dev/null; then
    log_info "installing k9s..."
    brew install k9s
  else
    log_info "k9s already installed — skipping"
  fi

  # ── Symlinks ─────────────────────────────────────────────────────────────────

  log_info "symlinking k9s config..."
  symlink "$DOTS/k9s/config/config.yaml" "$HOME/Library/Application Support/k9s/config.yaml"
  symlink "$DOTS/k9s/config/aliases.yaml" "$HOME/Library/Application Support/k9s/aliases.yaml"
  symlink "$DOTS/k9s/config/skins"        "$HOME/Library/Application Support/k9s/skins"
fi
