#!/usr/bin/env bash
DEPS=(homebrew php)

if ! command -v composer &>/dev/null; then
  log_info "installing composer..."
  if is_macos; then
    brew install composer
  elif is_arch; then
    sudo pacman -S --needed --noconfirm composer
  elif is_ubuntu; then
    sudo apt install -y composer
  fi
else
  log_info "composer already installed — skipping"
fi

composer global require laravel/installer
