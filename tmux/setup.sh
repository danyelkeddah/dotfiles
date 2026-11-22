#!/usr/bin/env bash

TPM="$HOME/.config/tmux/plugins/tpm"

install() {
  pkg_install tmux git

  if [ ! -d "$TPM" ]; then
    log_info "installing tpm..."
    git clone https://github.com/tmux-plugins/tpm "$TPM"
  else
    log_ok "tpm (already installed)"
  fi

  symlink "$DOTS/tmux/config/tmux.conf" "$HOME/.config/tmux/tmux.conf"
  symlink "$DOTS/tmux/config/themes"    "$HOME/.config/tmux/themes"
}

upgrade() {
  log_info "updating tpm..."
  git -C "$TPM" pull --ff-only
}

remove() {
  unlink_dot "$HOME/.config/tmux/tmux.conf"
  unlink_dot "$HOME/.config/tmux/themes"
}
