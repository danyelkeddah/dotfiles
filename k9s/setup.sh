#!/usr/bin/env bash
DEPS=(homebrew packages)

if ! command -v k9s &>/dev/null; then
  log_info "installing k9s..."
  if is_macos; then
    brew install k9s
  elif is_arch; then
    yay -S --needed --noconfirm k9s
  elif is_ubuntu; then
    curl -fLo /tmp/k9s.tar.gz \
    "https://github.com/derailed/k9s/releases/latest/download/k9s_Linux_amd64.tar.gz"
    tar -xf /tmp/k9s.tar.gz -C /tmp k9s
    sudo mv /tmp/k9s /usr/local/bin/k9s
  fi
  else
  log_info "k9s already installed — skipping"
fi


log_info "symlinking k9s config..."
if is_macos; then
  symlink "$DOTS/k9s/config/config.yaml"  "$HOME/Library/Application Support/k9s/config.yaml"
  symlink "$DOTS/k9s/config/aliases.yaml" "$HOME/Library/Application Support/k9s/aliases.yaml"
  symlink "$DOTS/k9s/config/skins"        "$HOME/Library/Application Support/k9s/skins"
elif is_arch || is_ubuntu; then
  symlink "$DOTS/k9s/config/config.yaml"  "$HOME/.config/k9s/config.yaml"
  symlink "$DOTS/k9s/config/aliases.yaml" "$HOME/.config/k9s/aliases.yaml"
  symlink "$DOTS/k9s/config/skins"        "$HOME/.config/k9s/skins"
fi
