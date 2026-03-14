#!/usr/bin/env bash
DEPS=(homebrew)

if is_macos; then
  log_info "installing fonts..."
  brew install --cask \
    font-jetbrains-mono \
    font-jetbrains-mono-nerd-font \
    font-fira-code \
    font-fira-code-nerd-font \
    font-meslo-lg-nerd-font \
    font-hack-nerd-font \
    font-cascadia-code \
    font-cascadia-mono \
    font-roboto \
    font-roboto-mono-nerd-font \
    font-inconsolata-nerd-font \
    font-sauce-code-pro-nerd-font \
    font-victor-mono-nerd-font \
    font-open-sans \
    font-monaspace
fi
