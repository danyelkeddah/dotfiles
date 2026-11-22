#!/usr/bin/env bash

COMPLETIONS="$HOME/.config/zsh/completions"
FZF_TAB="$HOME/.config/zsh/plugins/fzf-tab"

install() {
  local shell

  pkg_install zsh
  [ "$DOT_PKG" = brew ] && pkg_install zsh-completions

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

remove() {
  unlink_dot "$HOME/.zshrc"
  unlink_dot "$HOME/.config/zsh"
}

sync_secrets() {
  local key
  log_info "syncing anthropic api key..."
  # read first, on its own line: if 1Password fails, stop here rather than
  # store an empty key
  key="$(op read "op://Personal/d5qqmscjtlpcsv5e5uxhgfbeb4/anthropic - personal token")"
  upsert_secret "ANTHROPIC_API_KEY" "$key"
}

remove_secrets() {
  remove_secret "ANTHROPIC_API_KEY"
}
