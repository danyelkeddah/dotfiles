#!/usr/bin/env bash
# no uninstall(): too much else here depends on 1Password

AGENT="$HOME/.config/1Password/ssh/agent.toml"

install() {
  case "$DOT_PKG" in
    brew)
      pkg_install --cask 1password 1password-cli
      ;;
    apt)
      if ! pkg_installed 1password-cli; then
        apt_add_repo 1password \
          https://downloads.1password.com/linux/keys/1password.asc \
          "https://downloads.1password.com/linux/debian/$(dpkg --print-architecture) stable main"
      fi
      pkg_install 1password-cli
      ;;
    pacman)
      # only in the AUR
      if command -v op >/dev/null; then
        log_ok "1password-cli (already installed)"
      elif command -v yay >/dev/null; then
        yay -S --needed --noconfirm 1password-cli
      else
        log_warn "yay not found — 1password-cli not installed"
      fi
      ;;
    *)
      log_warn "1password-cli is not set up for '$DOT_PKG' — install it yourself"
      ;;
  esac
}

# the SSH agent belongs to the desktop app, which this package only installs on macOS
configure() {
  [ "$DOT_OS" = macos ] || return 0
  symlink "$DOTS/onepassword/config/ssh/agent.toml" "$AGENT"
}

unconfigure() {
  unlink_dot "$AGENT"
}
