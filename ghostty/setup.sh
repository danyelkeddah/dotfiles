#!/usr/bin/env bash
DEPS=(homebrew)

if is_macos; then
  log_info "installing ghostty..."
  brew install --cask ghostty


  log_info "symlinking config..."
  symlink "$DOTS/ghostty/config/config" "$HOME/.config/ghostty/config"

  log_warn "To install xterm-ghostty terminfo on a remote host, run: install-ghostty-terminfo user@host"
fi
