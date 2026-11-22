#!/usr/bin/env bash
only_on macos

install() {
  pkg_install --cask hammerspoon
  symlink "$DOTS/hammerspoon/config" "$HOME/.hammerspoon"
}

remove() {
  unlink_dot "$HOME/.hammerspoon"
}
