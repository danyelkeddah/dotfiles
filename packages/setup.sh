#!/usr/bin/env bash
DEPS=(homebrew)
if is_macos; then
  log_info "installing packages..."
  brew bundle --file="$DOTS/packages/config/Brewfile"

elif is_arch; then
  log_info "installing packages..."
  if command -v yay &>/dev/null; then
    log_info "installing aur packages..."
    yay -S --needed --noconfirm - < "$DOTS/packages/config/aur.txt"
  else
    log_err "yay not found — skipping aur packages"
  fi

elif is_ubuntu; then
  log_info "installing packages..."
  sudo apt install -y $(grep -v "^#" "$DOTS/packages/config/ubuntu.txt" | tr '\n' ' ')
fi
