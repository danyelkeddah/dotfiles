#!/usr/bin/env bash
DEPS=(homebrew)

if ! command -v php &>/dev/null; then
  log_info "installing php..."
  if is_macos; then
    brew tap shivammathur/php
    brew install shivammathur/php/php
  elif is_arch; then
    sudo pacman -S --needed --noconfirm php
  elif is_ubuntu; then
    sudo add-apt-repository -y ppa:ondrej/php
    sudo apt update
    sudo apt install -y php
  fi
else
  log_info "php already installed — skipping"
fi

