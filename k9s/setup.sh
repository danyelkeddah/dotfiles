#!/usr/bin/env bash

# k9s keeps its config in a different place on macOS
case "$DOT_OS" in
  macos) CONFIG="$HOME/Library/Application Support/k9s" ;;
  *)     CONFIG="$HOME/.config/k9s" ;;
esac

BIN="$HOME/.local/bin/k9s"

# the official release binary, into ~/.local/bin (needs no root)
k9s_download() {
  local arch tmp
  case "$DOT_ARCH" in
    x86_64) arch=amd64 ;;
    arm64)  arch=arm64 ;;
    *)      log_err "no k9s release for $DOT_ARCH"; return 1 ;;
  esac

  log_info "downloading k9s..."
  tmp="$(mktemp -d)"
  curl -fLo "$tmp/k9s.tar.gz" \
    "https://github.com/derailed/k9s/releases/latest/download/k9s_Linux_$arch.tar.gz"
  tar -xf "$tmp/k9s.tar.gz" -C "$tmp" k9s
  mkdir -p "$(dirname "$BIN")"
  mv "$tmp/k9s" "$BIN"
  rm -rf "$tmp"
}

install() {
  case "$DOT_PKG" in
    brew|pacman)
      pkg_install k9s
      ;;
    *)
      # not packaged for apt or dnf
      if command -v k9s >/dev/null; then
        log_ok "k9s (already installed)"
      else
        k9s_download
      fi
      ;;
  esac

  symlink "$DOTS/k9s/config/config.yaml"  "$CONFIG/config.yaml"
  symlink "$DOTS/k9s/config/aliases.yaml" "$CONFIG/aliases.yaml"
  symlink "$DOTS/k9s/config/skins"        "$CONFIG/skins"
}

upgrade() {
  # only the copy this package downloaded; a packaged one is upgraded by the system
  [ -x "$BIN" ] || return 0
  k9s_download
}

remove() {
  unlink_dot "$CONFIG/config.yaml"
  unlink_dot "$CONFIG/aliases.yaml"
  unlink_dot "$CONFIG/skins"
}
