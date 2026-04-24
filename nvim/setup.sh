#!/usr/bin/env bash
DEPS=(homebrew packages rust)

log_info "installing latest neovim..."

# Neovim publishes arm64 assets but Linux `uname -m` returns aarch64 — normalize
arch="$(uname -m | sed 's/aarch64/arm64/')"

if is_macos; then
  brew uninstall neovim &>/dev/null || true
  asset="nvim-macos-$arch"
elif is_arch; then
  sudo pacman -R --noconfirm neovim &>/dev/null || true
  asset="nvim-linux-$arch"
elif is_ubuntu; then
  sudo apt-get remove -y neovim neovim-runtime &>/dev/null || true
  asset="nvim-linux-$arch"
fi

rm -rf "$HOME/.opt/nvim"
mkdir -p "$HOME/.opt/nvim"
curl -fsSL "https://github.com/neovim/neovim/releases/latest/download/$asset.tar.gz" \
  | tar -xzf - -C "$HOME/.opt/nvim" --strip-components=1

symlink "$HOME/.opt/nvim/bin/nvim" "$HOME/.local/bin/nvim"
log_ok "neovim installed"

if ! command -v tree-sitter &>/dev/null; then
  log_info "installing tree-sitter CLI..."
  if is_macos; then
    brew install tree-sitter
  elif is_arch; then
    sudo pacman -S --needed --noconfirm tree-sitter
  elif is_ubuntu; then
    source "$HOME/.cargo/env"
    cargo install tree-sitter-cli
  fi
else
  log_info "tree-sitter already installed — skipping"
fi

log_info "symlinking neovim config..."
symlink "$DOTS/nvim/config" "$HOME/.config/nvim"
