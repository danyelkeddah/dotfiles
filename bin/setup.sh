#!/usr/bin/env bash
# my own scripts, linked into ~/.local/bin

BIN="$HOME/.local/bin"

configure() {
  local script
  mkdir -p "$BIN"
  for script in "$DOTS/bin/scripts/"*; do
    chmod +x "$script"
    symlink "$script" "$BIN/$(basename "$script")"
  done
}

unconfigure() {
  local script
  for script in "$DOTS/bin/scripts/"*; do
    unlink_dot "$BIN/$(basename "$script")"
  done
}
