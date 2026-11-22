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
      # A plain install fails when the local package database is missing or
      # older than the mirrors. Arch only supports fixing that with a full
      # upgrade (-Syu): refreshing the database alone (-Sy) and then installing
      # leaves a half-upgraded system with broken library dependencies.
      as_root pacman -S --needed --noconfirm $missing || {
        log_info "package database is out of date — upgrading the system, then retrying..."
        as_root pacman -Syu --needed --noconfirm $missing
      }
      ;;
    dnf)
      as_root dnf install -y $missing
      ;;
  esac
}

# pkg_uninstall [--cask] <name>... — remove packages with the system package
# manager. Names are the ones this manager uses; what isn't installed is skipped.
#
# On apt and pacman this deliberately does not pass -y / --noconfirm: the
# package manager lists anything else that depends on these and would go with
# them, and you get to say no. So it needs a terminal.
pkg_uninstall() {
  local cask="" installed="" name
  if [ "$1" = --cask ]; then cask=1; shift; fi

  for name in "$@"; do
    if pkg_installed ${cask:+--cask} "$name"; then installed="$installed $name"; fi
  done
  [ -n "$installed" ] || return 0

  case "$DOT_PKG" in
    brew)
      # one at a time: brew refuses a formula that another one still needs,
      # and that must not stop the rest
      for name in $installed; do
        brew uninstall ${cask:+--cask} "$name" \
          || log_warn "kept $name — brew says something still needs it"
      done
      ;;
    apt|pacman|dnf)
      if [ "$DOT_ROOT" = no ]; then
        log_warn "no root access — still installed:$installed"
      elif [ ! -t 0 ]; then
        log_warn "nobody to confirm with — still installed:$installed"
      else
        case "$DOT_PKG" in
          apt)    as_root apt-get remove $installed ;;
          pacman) as_root pacman -R $installed ;;
          dnf)    as_root dnf remove $installed ;;
        esac || log_warn "nothing was removed"
      fi
      ;;
  esac
}

# apt_add_repo <name> <key url> <repo line>
#
#   apt_add_repo charm https://repo.charm.sh/apt/gpg.key "https://repo.charm.sh/apt/ * *"
#
# Adds a third-party apt repository: saves its signing key under
# /etc/apt/keyrings and writes /etc/apt/sources.list.d/<name>.list. The repo
# line is what follows `deb [...]`: the URL, suite and components.
# Does nothing if the repo is already there, and only warns without root.
apt_add_repo() {
  local name="$1" key_url="$2" line="$3"
  local list="/etc/apt/sources.list.d/$name.list" key tmp

  if [ -f "$list" ]; then
    log_ok "$name apt repo (already added)"
    return 0
  fi
  if [ "$DOT_ROOT" = no ]; then
    log_warn "no root access — $name apt repo not added"
    return 0
  fi

  log_info "adding $name apt repo..."
  tmp="$(mktemp)"
  curl -fsSL "$key_url" -o "$tmp"
  # apt tells the two key formats apart by file extension
  if grep -q 'BEGIN PGP' "$tmp"; then key="/etc/apt/keyrings/$name.asc"
  else                                key="/etc/apt/keyrings/$name.gpg"
  fi
  # (not `install -D`: inside a package, `install` is the package's function)
  as_root mkdir -p /etc/apt/keyrings
  as_root cp "$tmp" "$key"
  as_root chmod 0644 "$key"
  rm -f "$tmp"

  echo "deb [arch=$(dpkg --print-architecture) signed-by=$key] $line" \
    | as_root tee "$list" >/dev/null

  # the package lists must be read again to see the new repo
  rm -f "$DOT_RUN_DIR/apt-updated"
}
