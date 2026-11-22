#!/usr/bin/env bash
# tmux itself is installed by mise; this package links its config and adds tpm
DEPS=(mise)

TPM="$HOME/.config/tmux/plugins/tpm"

install() {
  if [ -d "$TPM" ]; then
    log_ok "tpm (already installed)"
  else
    log_info "installing tpm..."
    git clone https://github.com/tmux-plugins/tpm "$TPM"
  fi
}

configure() {
  symlink "$DOTS/tmux/config/tmux.conf" "$HOME/.config/tmux/tmux.conf"
  symlink "$DOTS/tmux/config/themes"    "$HOME/.config/tmux/themes"
}

upgrade() {
  log_info "updating tpm..."
  git -C "$TPM" pull --ff-only
}

unconfigure() {
  unlink_dot "$HOME/.config/tmux/tmux.conf"
  unlink_dot "$HOME/.config/tmux/themes"
}

# tpm and the plugins it downloaded; tmux itself belongs to mise
uninstall() {
  rm -rf "$HOME/.config/tmux/plugins"
  log_ok "removed tmux plugins"
}
