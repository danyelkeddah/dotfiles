#!/usr/bin/env bash
DEPS=(homebrew)

if ! command -v gh &>/dev/null; then
  log_info "installing gh..."
  if is_macos; then
    brew tap github/gh
    brew install gh
  elif is_arch; then
    sudo pacman -S --needed --noconfirm github-cli
  elif is_ubuntu; then
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
      | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
      | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    sudo apt update
    sudo apt install -y gh
  fi
else
  log_info "gh already installed — skipping"
fi


if ! gh extension list | grep -q "dlvhdr/gh-dash"; then
  log_info "installing gh-dash..."
  gh extension install dlvhdr/gh-dash
else
  log_info "upgrading gh-dash..."
  gh extension upgrade dlvhdr/gh-dash
fi
