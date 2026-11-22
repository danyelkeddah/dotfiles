#!/usr/bin/env bash
# The basics every machine gets, one list per package manager, in config/.
# Databases and docker are in the services package, media and network tools in
# desktop-apps; neither runs on a server.

# the names in a list file, without comments and blank lines
list() { grep -v '^#' "$1" | grep -v '^[[:space:]]*$' || true; }

install() {
  local aur

  case "$DOT_PKG" in
    brew)
      brew bundle --file="$DOTS/packages/config/Brewfile"
      ;;
    apt)
      pkg_install $(list "$DOTS/packages/config/ubuntu.txt")
      ;;
    pacman)
      pkg_install $(list "$DOTS/packages/config/pacman.txt")

      aur="$(list "$DOTS/packages/config/aur.txt")"
      if [ -z "$aur" ]; then
        :
      elif command -v yay >/dev/null; then
        log_info "installing aur packages..."
        yay -S --needed --noconfirm $aur
      else
        log_warn "yay not found — aur packages not installed"
      fi
      ;;
    *)
      log_warn "no package list for '$DOT_PKG' — nothing installed"
      ;;
  esac
}
