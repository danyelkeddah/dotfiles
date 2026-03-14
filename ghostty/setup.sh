#!/usr/bin/env bash
DEPS=(homebrew)

if is_macos; then
  log_info "installing ghostty..."
  brew install --cask ghostty


  log_info "symlinking config..."
  symlink "$DOTS/ghostty/config/config" "$HOME/.config/ghostty/config"
fi
