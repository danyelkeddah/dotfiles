#!/usr/bin/env bash
only_on macos

install() {
  pkg_install --cask hammerspoon
}

configure() {
  symlink "$DOTS/hammerspoon/config" "$HOME/.hammerspoon"
}

unconfigure() {
  unlink_dot "$HOME/.hammerspoon"
}

uninstall() {
  pkg_uninstall --cask hammerspoon
}
