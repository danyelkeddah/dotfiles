#!/usr/bin/env bash
only_on macos

install() {
  pkg_install --cask ghostty
  symlink "$DOTS/ghostty/config/config" "$HOME/.config/ghostty/config"

  log_warn "To install xterm-ghostty terminfo on a remote host, run: install-ghostty-terminfo user@host"
}

remove() {
  unlink_dot "$HOME/.config/ghostty/config"
}
