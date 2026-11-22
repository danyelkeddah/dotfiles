#!/usr/bin/env bash
# no uninstall(): zsh is the login shell

COMPLETIONS="$HOME/.config/zsh/completions"
FZF_TAB="$HOME/.config/zsh/plugins/fzf-tab"

install() {
  pkg_install zsh
  [ "$DOT_PKG" = brew ] && pkg_install zsh-completions
  return 0
}

configure() {
  local shell

  # make it the login shell
  case "$DOT_PKG" in
    brew) shell="$(brew --prefix)/bin/zsh" ;;
    *)    shell="$(command -v zsh || true)" ;;
  esac
  if [ -z "$shell" ] || [ ! -x "$shell" ]; then
    log_warn "zsh is not installed — login shell left as it is"
  elif [ "$SHELL" = "$shell" ]; then
    log_ok "zsh (already the login shell)"
  elif [ "$DOT_ROOT" = no ]; then
    log_warn "no root access — make zsh your login shell yourself: chsh -s $shell"
  else
    log_info "setting zsh as the login shell..."
    as_root chsh -s "$shell" "$(id -un)"
  fi

  symlink "$DOTS/zsh/config/.zshrc" "$HOME/.zshrc"
  symlink "$DOTS/zsh/config/zsh"    "$HOME/.config/zsh"

  # both are cloned into the linked config folder, which .gitignore covers
  if [ -d "$COMPLETIONS" ]; then
    log_ok "zsh-completions (already installed)"
  else
    log_info "cloning zsh-completions..."
    git clone https://github.com/zsh-users/zsh-completions.git "$COMPLETIONS"
  fi

  if [ -d "$FZF_TAB" ]; then
    log_ok "fzf-tab (already installed)"
  else
    log_info "cloning fzf-tab..."
    git clone https://github.com/Aloxaf/fzf-tab "$FZF_TAB"
  fi
}

upgrade() {
  log_info "updating zsh-completions..."
  git -C "$COMPLETIONS" pull --ff-only
  log_info "updating fzf-tab..."
  git -C "$FZF_TAB" pull --ff-only
}

# the login shell is left as it is
unconfigure() {
  unlink_dot "$HOME/.zshrc"
  unlink_dot "$HOME/.config/zsh"
}
