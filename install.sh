#!/bin/sh
# install.sh — get these dotfiles onto a bare machine and hand over to dot.
#
#   curl -fsSL https://raw.githubusercontent.com/danyelkeddah/dotfiles/main/install.sh | sh
#
# Arguments are passed on to dot:
#
#   curl -fsSL .../install.sh | sh -s -- tmux zsh
#
# POSIX sh on purpose: this is the only file that has to run before anything
# else is installed. It does three things and nothing more:
#   1. make sure git, curl and bash exist
#   2. clone the repo (skipped if it is already there)
#   3. run dot
#
# Settings:
#   DOTFILES_REPO   where to clone from   (default: the GitHub repo over https)
#   DOTFILES_DIR    where to clone to     (default: ~/.dotfiles)
set -eu

REPO="${DOTFILES_REPO:-https://github.com/danyelkeddah/dotfiles.git}"
DEST="${DOTFILES_DIR:-$HOME/.dotfiles}"

say()  { printf '\033[1;36m  → %s\033[0m\n' "$1"; }
fail() { printf '\033[1;31m  ✗ %s\033[0m\n' "$1" >&2; exit 1; }
have() { command -v "$1" >/dev/null 2>&1; }

as_root() {
  if [ "$(id -u)" = 0 ]; then
    "$@"
  elif have sudo; then
    sudo "$@"
  else
    fail "need root to run: $* — install git, curl and bash yourself, then re-run"
  fi
}

# ── 1. git, curl, bash ────────────────────────────────────────────────────────

missing=""
for tool in git curl bash; do
  have "$tool" || missing="$missing $tool"
done

if [ "$(uname -s)" = Darwin ]; then
  # macOS ships curl and bash; git comes with the Command Line Tools, and
  # /usr/bin/git is only a stub that opens a dialog until they are installed
  if ! xcode-select -p >/dev/null 2>&1; then
    say "installing Xcode Command Line Tools — finish the dialog, then run this again"
    xcode-select --install || true
    exit 1
  fi
elif [ -n "$missing" ]; then
  say "installing:$missing"
  if have apt-get; then
    as_root apt-get update
    # shellcheck disable=SC2086
    as_root env DEBIAN_FRONTEND=noninteractive apt-get install -y ca-certificates $missing
  elif have pacman; then
    # shellcheck disable=SC2086
    # no (or a stale) package database: Arch only supports a full upgrade here
    as_root pacman -S --needed --noconfirm $missing \
      || as_root pacman -Syu --needed --noconfirm $missing
  elif have dnf; then
    # shellcheck disable=SC2086
    as_root dnf install -y $missing
  else
    fail "no known package manager — install$missing yourself, then re-run"
  fi
fi

# ── 2. clone ──────────────────────────────────────────────────────────────────

if [ -d "$DEST/.git" ]; then
  say "$DEST already cloned — leaving it as is (update with: dot update)"
elif [ -e "$DEST" ]; then
  fail "$DEST exists but is not a git checkout — move it away, then re-run"
else
  say "cloning $REPO → $DEST"
  git clone "$REPO" "$DEST"
fi

# ── 3. hand over ──────────────────────────────────────────────────────────────

# under `curl | sh` stdin is this script, so give dot the real terminal back
# for any prompts (when there is one)
if [ ! -t 0 ] && (: </dev/tty) 2>/dev/null; then
  exec bash "$DEST/dot" "$@" </dev/tty
fi
exec bash "$DEST/dot" "$@"
