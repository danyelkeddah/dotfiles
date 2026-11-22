#!/usr/bin/env bash
only_on macos

install() {
  if command -v brew >/dev/null; then
    log_ok "homebrew (already installed)"
  else
    log_info "installing homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
}
