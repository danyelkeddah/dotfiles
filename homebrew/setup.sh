#!/usr/bin/env bash

if is_macos; then
  if ! command -v brew &>/dev/null; then
    log_info "installing homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  else
    log_info "homebrew already installed — skipping"
  fi
fi
