#!/usr/bin/env bash
DEPS=(homebrew packages)

if is_macos; then
  if ! brew list --cask 1password &>/dev/null; then
    log_info "installing 1password..."
    brew install --cask 1password 1password-cli
  else
    log_info "1password already installed — skipping"
  fi

  log_info "symlinking agent.toml..."
  symlink "$DOTS/onepassword/config/ssh/agent.toml" "$HOME/.config/1Password/ssh/agent.toml"

elif is_ubuntu || is_arch; then
  if ! command -v op &>/dev/null; then
    log_info "installing 1password-cli..."
    if is_ubuntu; then
      curl -fsSL https://downloads.1password.com/linux/keys/1password.asc \
        | sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
      echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/$(dpkg --print-architecture) stable main" \
        | sudo tee /etc/apt/sources.list.d/1password.list
      sudo apt update
      sudo apt install -y 1password-cli
    elif is_arch; then
      yay -S --needed --noconfirm 1password-cli
    fi
  else
    log_info "1password-cli already installed — skipping"
  fi
fi
