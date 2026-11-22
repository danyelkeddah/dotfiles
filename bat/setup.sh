#!/usr/bin/env bash

THEME="$DOTS/bat/config/themes/Catppuccin Mocha.tmTheme"

install() {
  pkg_install bat

  # Debian and Ubuntu install the binary as `batcat`
  if ! command -v bat >/dev/null && command -v batcat >/dev/null; then
    mkdir -p "$HOME/.local/bin"
    ln -sf "$(command -v batcat)" "$HOME/.local/bin/bat"
    log_ok "linked: batcat → ~/.local/bin/bat"
  fi

  symlink "$DOTS/bat/config" "$HOME/.config/bat"

  if command -v bat >/dev/null; then
    log_info "building bat cache..."
    bat cache --build
  fi
}

# the theme file is kept in this repo; this fetches the latest copy of it
upgrade() {
  log_info "downloading Catppuccin Mocha theme..."
  curl -fLo "$THEME" --create-dirs \
    "https://raw.githubusercontent.com/catppuccin/bat/main/themes/Catppuccin%20Mocha.tmTheme"
  bat cache --build
}

remove() {
  unlink_dot "$HOME/.config/bat"
}
