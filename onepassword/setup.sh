#!/usr/bin/env bash
DEPS=(homebrew)

if is_macos; then
  log_info "installing 1password..."
  brew install --cask 1password 1password-cli

  log_info "symlinking agent.toml..."
  symlink "$DOTS/onepassword/config/ssh/agent.toml" "$HOME/.config/1Password/ssh/agent.toml"
fi



