#!/usr/bin/env bash
DEPS=(homebrew)

if is_macos; then

  if ! brew list --cask hammerspoon &>/dev/null; then
    log_info "installing hammerspoon..."
    brew install --cask hammerspoon
  else
    log_info "hammerspoon already installed — skipping"
  fi


  log_info "symlinking hammerspoon config..."
  symlink "$DOTS/hammerspoon/config" "$HOME/.hammerspoon"
fi
