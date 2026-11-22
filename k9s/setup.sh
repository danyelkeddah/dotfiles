#!/usr/bin/env bash
# k9s itself is installed by mise; this package links its config
DEPS=(mise)

# k9s keeps its config in a different place on macOS
case "$DOT_OS" in
  macos) CONFIG="$HOME/Library/Application Support/k9s" ;;
  *)     CONFIG="$HOME/.config/k9s" ;;
esac

configure() {
  symlink "$DOTS/k9s/config/config.yaml"  "$CONFIG/config.yaml"
  symlink "$DOTS/k9s/config/aliases.yaml" "$CONFIG/aliases.yaml"
  symlink "$DOTS/k9s/config/skins"        "$CONFIG/skins"
}

unconfigure() {
  unlink_dot "$CONFIG/config.yaml"
  unlink_dot "$CONFIG/aliases.yaml"
  unlink_dot "$CONFIG/skins"
}
