#!/usr/bin/env bash
DEPS=(homebrew packages)

if ! command -v gum &>/dev/null; then
  log_info "installing gum..."
  if is_macos; then
    brew install gum
  elif is_arch; then
    sudo pacman -S --needed --noconfirm gum
  elif is_ubuntu; then
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://repo.charm.sh/apt/gpg.key \
      | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
    echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" \
      | sudo tee /etc/apt/sources.list.d/charm.list
    sudo apt update
    sudo apt install -y gum
  fi
else
  log_info "gum already installed — skipping"
fi
