#!/usr/bin/env bash

FZF_DIR="$HOME/.fzf"

# apt's fzf is too old, so there it is installed from git into ~/.fzf.
# --no-update-rc: .zshrc already sources ~/.fzf.zsh, and .zshrc is a link into
# this repo — the installer must not write to it.
fzf_from_git() {
  "$FZF_DIR/install" --key-bindings --completion --no-update-rc --no-bash --no-fish
}

install() {
  if [ "$DOT_PKG" != apt ]; then
    pkg_install fzf
    return
  fi

  if [ -d "$FZF_DIR" ]; then
    log_ok "fzf (already installed)"
  else
    log_info "cloning fzf..."
    git clone --depth 1 https://github.com/junegunn/fzf.git "$FZF_DIR"
    fzf_from_git
  fi
}

upgrade() {
  # elsewhere the system upgrade takes care of it
  [ -d "$FZF_DIR" ] || return 0
  log_info "updating fzf..."
  git -C "$FZF_DIR" pull --ff-only
  fzf_from_git
}
