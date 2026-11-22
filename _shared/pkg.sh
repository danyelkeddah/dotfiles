#!/usr/bin/env bash
# _shared/pkg.sh
#
# Installing software with the SYSTEM package manager ($DOT_PKG).
# pnpm, cargo, composer and friends are the same on every OS — packages call
# those directly instead of going through here.

# run a command as root: directly when already root, through sudo otherwise
as_root() {
  if [ "$(id -u)" = 0 ]; then "$@"; else sudo "$@"; fi
}

# pkg_installed [--cask] <name> — is this package installed?
# Asks the package manager, which needs no root and doesn't guess from command
# names (ripgrep installs `rg`, fd-find installs `fdfind`, ...).
pkg_installed() {
  local cask=""
  if [ "$1" = --cask ]; then cask=1; shift; fi

  case "$DOT_PKG" in
    brew)
      if [ -n "$cask" ]; then brew list --cask "$1" >/dev/null 2>&1
      else                    brew list --formula "$1" >/dev/null 2>&1
      fi
      ;;
    # dpkg -s also succeeds for removed-but-not-purged packages, so read the status
    apt)    dpkg-query -W -f='${Status}' "$1" 2>/dev/null | grep -q 'ok installed' ;;
    pacman) pacman -Q "$1" >/dev/null 2>&1 ;;
    dnf)    rpm -q "$1" >/dev/null 2>&1 ;;
    *)      return 1 ;;
  esac
}

# pkg_install [--cask] <name> [<manager>=<name>]... [<name> ...]
#
#   pkg_install tmux                    same name everywhere
#   pkg_install tmux git                several at once
#   pkg_install fd apt=fd-find          called fd-find on apt, fd elsewhere
#   pkg_install --cask ghostty          a Homebrew cask (--cask is ignored elsewhere)
#
# A <manager>=<name> word renames the package just before it, on that manager only.
#
# Already-installed packages are skipped. Without root access the missing ones
# are reported and the script carries on, so config still gets linked.
pkg_install() {
  local cask="" wanted="" current="" missing="" arg name

  # work out the right name of each package for this machine
  for arg in "$@"; do
    case "$arg" in
      --cask) cask=1 ;;
      *=*)    [ "${arg%%=*}" = "$DOT_PKG" ] && current="${arg#*=}" ;;
      *)      wanted="$wanted $current"; current="$arg" ;;
    esac
  done
  wanted="$wanted $current"

  for name in $wanted; do
    if pkg_installed ${cask:+--cask} "$name"; then
      log_ok "$name (already installed)"
    else
      missing="$missing $name"
    fi
  done
  [ -n "$missing" ] || return 0

  if [ "$DOT_PKG" = none ]; then
    log_warn "no known package manager — install yourself:$missing"
    return 0
  fi
  if [ "$DOT_PKG" != brew ] && [ "$DOT_ROOT" = no ]; then
    log_warn "no root access — not installed:$missing"
    return 0
  fi

  log_info "installing$missing..."
  # $missing is left unquoted on purpose: one word per package
  case "$DOT_PKG" in
    brew)
      HOMEBREW_NO_ENV_HINTS=1 brew install ${cask:+--cask} $missing
      ;;
    apt)
      # refresh the package lists once per dot run, not once per package
      if [ ! -f "$DOT_RUN_DIR/apt-updated" ]; then
        as_root apt-get update
        touch "$DOT_RUN_DIR/apt-updated"
      fi
      as_root env DEBIAN_FRONTEND=noninteractive apt-get install -y $missing
      ;;
    pacman)
      # -Sy without -u is avoided on purpose (it can leave a half-upgraded
      # system), so the database is only refreshed when a plain install fails —
      # e.g. on a fresh machine that has no database yet
      as_root pacman -S --needed --noconfirm $missing || {
        log_info "refreshing package database and retrying..."
        as_root pacman -Sy --needed --noconfirm $missing
      }
      ;;
    dnf)
      as_root dnf install -y $missing
      ;;
  esac
}
