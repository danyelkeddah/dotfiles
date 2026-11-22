#!/usr/bin/env bash
only_on macos

install() {
  pkg_install --cask ghostty
  log_warn "To install xterm-ghostty terminfo on a remote host, run: install-ghostty-terminfo user@host"
}

configure() {
  symlink "$DOTS/ghostty/config/config" "$HOME/.config/ghostty/config"
}

unconfigure() {
  unlink_dot "$HOME/.config/ghostty/config"
}

uninstall() {
  pkg_uninstall --cask ghostty
}
