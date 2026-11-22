#!/usr/bin/env bash
# Databases and docker — background services for a machine I develop on.
#
# Not for servers: on a headless machine this package skips itself. To install
# it there anyway, say so for that run:  DOT_ENV=desktop dot services
#
# On macOS these come from the Brewfile, in the packages package.
only_on linux desktop

# the names in a list file, without comments and blank lines
list() { grep -v '^#' "$1" | grep -v '^[[:space:]]*$' || true; }

install() {
  case "$DOT_PKG" in
    apt) pkg_install $(list "$DOTS/services/config/ubuntu.txt") ;;
    *)   log_warn "no services list for '$DOT_PKG' — nothing installed" ;;
  esac
}
