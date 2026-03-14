#!/usr/bin/env bash
DEPS=(homebrew php)

if is_macos; then
  log_info "installing composer..."
  brew install composer

  composer global require laravel/installer
fi


