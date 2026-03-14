#!/usr/bin/env bash

if [ ! -f "$HOME/.nvm/nvm.sh" ]; then
  log_info "fetching latest nvm version..."
  nvm_version=$(curl -fsSL https://api.github.com/repos/nvm-sh/nvm/releases/latest \
    | grep '"tag_name"' \
    | sed 's/.*"tag_name": "\(.*\)".*/\1/')

  log_info "installing nvm $nvm_version..."
  curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/$nvm_version/install.sh" | bash
else
  log_info "nvm already installed — skipping"
fi
