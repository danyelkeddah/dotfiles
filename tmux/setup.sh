#!/usr/bin/env bash
DEPS=(homebrew)

if ! command -v tmux &>/dev/null; then
  log_info "installing tmux..."
  if is_macos;    then brew install tmux
  elif is_arch;   then sudo pacman -S --needed --noconfirm tmux
  elif is_ubuntu; then sudo apt install -y tmux
  fi
else
  log_info "tmux already installed — skipping"
fi

if [ ! -d "$HOME/.config/tmux/plugins/tpm" ]; then
  log_info "installing tpm..."
  git clone https://github.com/tmux-plugins/tpm "$HOME/.config/tmux/plugins/tpm"
else
  log_info "tpm already installed — skipping"
fi

log_info "symlinking tmux config..."
symlink "$DOTS/tmux/config/tmux.conf" "$HOME/.config/tmux/tmux.conf"
symlink "$DOTS/tmux/config/themes"    "$HOME/.config/tmux/themes"
