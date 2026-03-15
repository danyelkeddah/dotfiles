# fzf/setup.sh

if ! command -v fzf &>/dev/null || [[ "$(fzf --version | cut -d' ' -f1)" < "0.48" ]]; then
  log_info "installing latest fzf..."
  if is_macos; then
    brew install fzf
  elif is_arch; then
    sudo pacman -S --needed --noconfirm fzf
  elif is_ubuntu; then
    # apt version is outdated — install via git
    if [ -d "$HOME/.fzf" ]; then
      log_info "updating fzf..."
      git -C "$HOME/.fzf" pull --force
    else
      log_info "cloning fzf..."
      git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
    fi
    "$HOME/.fzf/install" --all --no-bash --no-fish
  fi
else
  log_info "fzf already up to date — skipping"
fi
