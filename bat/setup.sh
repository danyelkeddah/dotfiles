#!/usr/bin/env bash
# bat itself is installed by mise; this package links its config and theme
DEPS=(mise)

THEME="$DOTS/bat/config/themes/Catppuccin Mocha.tmTheme"

configure() {
  symlink "$DOTS/bat/config" "$HOME/.config/bat"

  log_info "building bat cache..."
  bat cache --build
}

# the theme file is kept in this repo; this fetches the latest copy of it
upgrade() {
  log_info "downloading Catppuccin Mocha theme..."
  curl -fLo "$THEME" --create-dirs \
    "https://raw.githubusercontent.com/catppuccin/bat/main/themes/Catppuccin%20Mocha.tmTheme"
  bat cache --build
}

unconfigure() {
  unlink_dot "$HOME/.config/bat"
}
