#!/usr/bin/env bash
DEPS=(rust)

NVIM_DIR="$HOME/.opt/nvim"

# the official release build, unpacked into ~/.opt/nvim (needs no root).
# The config needs a newer Neovim than most package managers ship.
nvim_download() {
  local asset
  case "$DOT_OS" in
    macos) asset="nvim-macos-$DOT_ARCH" ;;
    *)     asset="nvim-linux-$DOT_ARCH" ;;
  esac

  log_info "downloading latest neovim..."
  rm -rf "$NVIM_DIR.new"
  mkdir -p "$NVIM_DIR.new"
  curl -fsSL "https://github.com/neovim/neovim/releases/latest/download/$asset.tar.gz" \
    | tar -xzf - -C "$NVIM_DIR.new" --strip-components=1
  rm -rf "$NVIM_DIR"
  mv "$NVIM_DIR.new" "$NVIM_DIR"

  mkdir -p "$HOME/.local/bin"
  ln -sf "$NVIM_DIR/bin/nvim" "$HOME/.local/bin/nvim"
}

install() {
  if [ -x "$NVIM_DIR/bin/nvim" ]; then
    log_ok "neovim (already installed)"
  else
    nvim_download
  fi

  if command -v tree-sitter >/dev/null; then
    log_ok "tree-sitter (already installed)"
  else
    case "$DOT_PKG" in
      brew)   pkg_install tree-sitter ;;
      pacman) pkg_install tree-sitter-cli ;;
      *)
        # built from source, which needs a C compiler
        pkg_install gcc apt=build-essential
        log_info "installing tree-sitter CLI..."
        cargo install tree-sitter-cli
        ;;
    esac
  fi

  symlink "$DOTS/nvim/config" "$HOME/.config/nvim"
}

upgrade() {
  nvim_download
}

remove() {
  unlink_dot "$HOME/.config/nvim"
}
