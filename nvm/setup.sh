#!/usr/bin/env bash

# install (or update to) the latest nvm release
nvm_latest() {
  local version
  log_info "fetching latest nvm version..."
  version="$(curl -fsSL https://api.github.com/repos/nvm-sh/nvm/releases/latest \
    | grep '"tag_name"' \
    | sed 's/.*"tag_name": "\(.*\)".*/\1/')"

  log_info "installing nvm $version..."
  # PROFILE=/dev/null: .zshrc already loads nvm, and .zshrc is a link into this
  # repo — the installer must not write to it
  curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/$version/install.sh" \
    | PROFILE=/dev/null bash
}

install() {
  if [ -f "$HOME/.nvm/nvm.sh" ]; then
    log_ok "nvm (already installed)"
  else
    nvm_latest
  fi
}

upgrade() {
  nvm_latest
}
