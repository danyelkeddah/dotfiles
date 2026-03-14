#!/usr/bin/env bash
DEPS=(homebrew)

if is_macos; then
  log_info "installing bat..."
  brew install --cask bat
fi


log_info "downloading Catppuccin Mocha theme..."
curl -fLo "$DOTS/bat/config/themes/Catppuccin Mocha.tmTheme" \
  --create-dirs \
  "https://raw.githubusercontent.com/catppuccin/bat/main/themes/Catppuccin%20Mocha.tmTheme"

log_info "symlinking bat config..."
symlink "$DOTS/bat/config" "$HOME/.config/bat"

log_info "building bat cache..."
bat cache --build
