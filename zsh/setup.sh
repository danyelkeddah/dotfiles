#!/usr/bin/env bash
DEPS=(homebrew)

if is_macos; then
  if ! command -v zsh &>/dev/null; then
    log_info "installing zsh..."
    brew install zsh zsh-completions
  else
    log_info "zsh already installed — skipping"
  fi

  # set default shell to homebrew zsh
  if [ "$SHELL" != "/opt/homebrew/bin/zsh" ]; then
    log_info "setting zsh as default shell..."
    sudo chsh -s /opt/homebrew/bin/zsh "$USER"
  else
    log_info "zsh already default shell — skipping"
  fi

elif is_ubuntu; then
  if ! command -v zsh &>/dev/null; then
    log_info "installing zsh..."
    sudo apt install -y zsh
  else
    log_info "zsh already installed — skipping"
  fi

  # set default shell to system zsh
  if [ "$SHELL" != "/usr/bin/zsh" ]; then
    log_info "setting zsh as default shell..."
    sudo chsh -s /usr/bin/zsh "$USER"
  else
    log_info "zsh already default shell — skipping"
  fi

elif is_arch; then
  if ! command -v zsh &>/dev/null; then
    log_info "installing zsh..."
    sudo pacman -S --needed --noconfirm zsh
  else
    log_info "zsh already installed — skipping"
  fi

  if [ "$SHELL" != "/usr/bin/zsh" ]; then
    log_info "setting zsh as default shell..."
    sudo chsh -s /usr/bin/zsh "$USER"
  else
    log_info "zsh already default shell — skipping"
  fi
fi



# ── Symlinks ──────────────────────────────────────────────────────────────────

log_info "symlinking zsh config..."
symlink "$DOTS/zsh/config/.zshrc"      "$HOME/.zshrc"
symlink "$DOTS/zsh/config/zsh"         "$HOME/.config/zsh"


if [ ! -d "$HOME/.config/zsh/completions" ]; then
  log_info "cloning zsh-completions..."
  git clone https://github.com/zsh-users/zsh-completions.git "$HOME/.config/zsh/completions"
else
  log_info "updating zsh-completions..."
  git -C "$HOME/.config/zsh/completions" pull --force
fi


if [ ! -d "$HOME/.config/zsh/plugins/fzf-tab" ]; then
  log_info "cloning fzf-tab..."
  git clone https://github.com/Aloxaf/fzf-tab "$HOME/.config/zsh/plugins/fzf-tab"
  else
  log_info "updating fzf-tab..."
  git -C "$HOME/.config/zsh/plugins/fzf-tab" pull --force
fi
