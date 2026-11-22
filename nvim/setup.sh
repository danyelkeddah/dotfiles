#!/usr/bin/env bash
# neovim and the tree-sitter CLI are installed by mise; this package links
# the config
DEPS=(mise)

configure() {
  symlink "$DOTS/nvim/config" "$HOME/.config/nvim"
}

unconfigure() {
  unlink_dot "$HOME/.config/nvim"
}
