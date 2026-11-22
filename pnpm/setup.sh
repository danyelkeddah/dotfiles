#!/usr/bin/env bash
# pnpm itself is installed by mise; this package only links its config
DEPS=(mise)

# pnpm keeps its global config in a different place on each OS
case "$DOT_OS" in
  macos) CONFIG="$HOME/Library/Preferences/pnpm/config.yaml" ;;
  *)     CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/pnpm/config.yaml" ;;
esac

configure() {
  symlink "$DOTS/pnpm/config/config.yaml" "$CONFIG"
}

unconfigure() {
  unlink_dot "$CONFIG"
}
