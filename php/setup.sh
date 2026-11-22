#!/usr/bin/env bash

install() {
  if command -v php >/dev/null; then
    log_ok "php (already installed)"
    return 0
  fi

  case "$DOT_PKG" in
    brew)
      brew tap shivammathur/php
      pkg_install shivammathur/php/php
      ;;
    apt)
      # newer PHP than the distro's own; the PPA only exists for Ubuntu
      apt_add_ppa ppa:ondrej/php
      pkg_install php
      ;;
    *)
      pkg_install php
      ;;
  esac
}
