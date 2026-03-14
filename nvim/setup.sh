#!/usr/bin/env bash
DEPS=(homebrew)

if is_macos; then
  if ! command -v nvim &>/dev/null; then
    log_info "installing neovim..."
    brew install neovim
  else
    log_info "neovim already installed — skipping"
  fi

  log_info "symlinking neovim config..."
  symlink "$DOTS/nvim/config" "$HOME/.config/nvim"
fi
