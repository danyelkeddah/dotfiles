#!/usr/bin/env bash
DEPS=(php)

install() {
  pkg_install composer

  if ! command -v composer >/dev/null; then
    log_warn "composer is not installed — skipping laravel/installer"
    return 0
  fi
  composer global require laravel/installer
}

upgrade() {
  composer global update
}
