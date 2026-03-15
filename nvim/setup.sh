#!/usr/bin/env bash
DEPS=(homebrew packages)

if ! command -v nvim &>/dev/null; then
  log_info "installing neovim..."
  if is_macos; then
    brew install neovim
  elif is_arch; then
    sudo pacman -S --needed --noconfirm neovim
  elif is_ubuntu; then
    log_info "adding neovim ppa..."
    sudo add-apt-repository -y ppa:neovim-ppa/unstable
    sudo apt update
    sudo apt install -y neovim
  fi
else
  log_info "neovim already installed — skipping"
fi

log_info "symlinking neovim config..."
symlink "$DOTS/nvim/config" "$HOME/.config/nvim"
