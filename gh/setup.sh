#!/usr/bin/env bash
DEPS=(homebrew)

if is_macos; then

  if ! command -v gh &>/dev/null; then
    log_info "installing gh..."
    brew tap github/gh
    brew install gh
  else
    log_info "gh already installed — skipping"
  fi


  if ! gh extension list | grep -q "dlvhdr/gh-dash"; then
    log_info "installing gh-dash..."
    gh extension install dlvhdr/gh-dash
  else
    log_info "upgrading gh-dash..."
    gh extension upgrade dlvhdr/gh-dash
  fi
fi
