#!/usr/bin/env bash
# _shared/platform.sh
#
# Works out what kind of machine this is, once, and exports the answers.
# Everything else reads these variables instead of probing the system again.
# Print them with: dot --facts
#
#   DOT_OS      macos | linux
#   DOT_DISTRO  macos | arch | debian | fedora | <raw id> | unknown
#               (families: ubuntu/pop/mint → debian, manjaro → arch, rhel → fedora)
#   DOT_PKG     brew | pacman | apt | dnf | none      the SYSTEM package manager
#               only — pnpm, cargo, composer... are the same on every OS, so
#               packages call those directly
#   DOT_ARCH    x86_64 | arm64 | <raw>
#   DOT_ENV     desktop | headless | wsl | container
#   DOT_ROOT    yes | no      can this user become root?
#
# Any of them can be forced from outside, e.g.  DOT_ENV=headless dot

# ── OS ────────────────────────────────────────────────────────────────────────

if [ -z "${DOT_OS:-}" ]; then
  case "$(uname -s)" in
    Darwin) DOT_OS=macos ;;
    Linux)  DOT_OS=linux ;;
    *)      DOT_OS=unknown ;;
  esac
fi

# ── Distro family ─────────────────────────────────────────────────────────────

if [ -z "${DOT_DISTRO:-}" ]; then
  if [ "$DOT_OS" = macos ]; then
    DOT_DISTRO=macos
  else
    # read in a subshell so os-release variables don't leak into ours
    _id="$( . /etc/os-release 2>/dev/null; echo "${ID:-}")"
    _like="$(. /etc/os-release 2>/dev/null; echo "${ID_LIKE:-}")"
    case " $_id $_like " in
      *" arch "*)                DOT_DISTRO=arch ;;
      *" debian "*|*" ubuntu "*) DOT_DISTRO=debian ;;
      *" fedora "*|*" rhel "*)   DOT_DISTRO=fedora ;;
      *)                         DOT_DISTRO="${_id:-unknown}" ;;
    esac
    unset _id _like
  fi
fi

# ── System package manager ────────────────────────────────────────────────────

if [ -z "${DOT_PKG:-}" ]; then
  case "$DOT_DISTRO" in
    macos)  DOT_PKG=brew ;;   # installed by the homebrew package if missing
    arch)   DOT_PKG=pacman ;;
    debian) DOT_PKG=apt ;;
    fedora) DOT_PKG=dnf ;;
    *)
      if   command -v pacman  >/dev/null 2>&1; then DOT_PKG=pacman
      elif command -v apt-get >/dev/null 2>&1; then DOT_PKG=apt
      elif command -v dnf     >/dev/null 2>&1; then DOT_PKG=dnf
      else DOT_PKG=none
      fi
      ;;
  esac
fi

# ── CPU architecture ──────────────────────────────────────────────────────────

if [ -z "${DOT_ARCH:-}" ]; then
  case "$(uname -m)" in
    x86_64|amd64)  DOT_ARCH=x86_64 ;;
    arm64|aarch64) DOT_ARCH=arm64 ;;
    *)             DOT_ARCH="$(uname -m)" ;;
  esac
fi

# ── Environment ───────────────────────────────────────────────────────────────

if [ -z "${DOT_ENV:-}" ]; then
  if [ "$DOT_OS" = macos ]; then
    DOT_ENV=desktop
  elif [ -f /.dockerenv ] || [ -f /run/.containerenv ] || [ -n "${container:-}" ]; then
    DOT_ENV=container
  elif grep -qi microsoft /proc/version 2>/dev/null; then
    DOT_ENV=wsl
  elif [ -n "${DISPLAY:-}" ] || [ -n "${WAYLAND_DISPLAY:-}" ] \
    || [ -d /usr/share/xsessions ] || [ -d /usr/share/wayland-sessions ]; then
    # a display now, or a desktop session installed (covers ssh into a desktop)
    DOT_ENV=desktop
  else
    DOT_ENV=headless
  fi
fi

# ── Root access ───────────────────────────────────────────────────────────────

if [ -z "${DOT_ROOT:-}" ]; then
  # Deliberately no `sudo -n true` probe: for a user who is not in sudoers it
  # gets logged as a failed attempt. Group membership is a quiet enough signal.
  # If your sudo access comes from a custom sudoers rule, set DOT_ROOT=yes.
  if [ "$(id -u)" = 0 ]; then
    DOT_ROOT=yes
  elif ! command -v sudo >/dev/null 2>&1; then
    DOT_ROOT=no
  elif id -Gn | tr ' ' '\n' | grep -qxE 'sudo|wheel|admin'; then
    DOT_ROOT=yes
  else
    DOT_ROOT=no
  fi
fi

export DOT_OS DOT_DISTRO DOT_PKG DOT_ARCH DOT_ENV DOT_ROOT

# ── Checks ────────────────────────────────────────────────────────────────────

# TEMPORARY: only the not-yet-converted setup.sh files use these. Converted
# packages read DOT_OS / DOT_DISTRO or call only_on. Delete all three, and
# their names in dot's `export -f`, once the last package is converted.
is_macos()  { [ "$DOT_OS" = macos ]; }
is_arch()   { [ "$DOT_DISTRO" = arch ]; }
is_ubuntu() { [ "$DOT_DISTRO" = debian ]; }

# only_on <word>... — skip this package unless the machine matches.
#
#   only_on macos              macOS only
#   only_on linux desktop      Linux AND a desktop
#   only_on arch debian        Arch OR Debian family
#
# Words of the same kind are alternatives; different kinds must all match.
#   os:      macos linux
#   distro:  arch debian fedora
#   env:     desktop headless wsl container
only_on() {
  local os="" distro="" env="" word
  for word in "$@"; do
    case "$word" in
      macos|linux)                    os="$os $word" ;;
      arch|debian|fedora)             distro="$distro $word" ;;
      desktop|headless|wsl|container) env="$env $word" ;;
      *) log_err "only_on: unknown word '$word'"; exit 1 ;;
    esac
  done

  if { [ -n "$os" ]     && [[ " $os " != *" $DOT_OS "* ]]; } \
  || { [ -n "$distro" ] && [[ " $distro " != *" $DOT_DISTRO "* ]]; } \
  || { [ -n "$env" ]    && [[ " $env " != *" $DOT_ENV "* ]]; }; then
    log_info "skipped — only on: $*"
    exit 100   # dot reads 100 as "skipped", not as a failure
  fi
}
