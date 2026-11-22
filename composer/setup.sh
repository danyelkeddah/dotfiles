#!/usr/bin/env bash
# composer itself comes with mise's php; this package adds what I install with it
DEPS=(mise)

install() {
  # no php on this machine (see mise/setup.sh), so no composer either
  if ! command -v composer >/dev/null; then
    log_warn "composer is not installed — skipping laravel/installer"
    return 0
  fi

  if composer global show laravel/installer >/dev/null 2>&1; then
    log_ok "laravel/installer (already installed)"
  else
    log_info "installing laravel/installer..."
    composer global require laravel/installer
  fi
}

upgrade() {
  composer global update
}

uninstall() {
  composer global remove laravel/installer
}
