#!/usr/bin/env bash
# _shared/os.sh
#
# Linking config files into place, and taking them out again.


# ── Symlink ───────────────────────────────────────────────────────────────────

symlink() {
  local src="$1"
  local dest="${2/#\~/$HOME}"

  mkdir -p "$(dirname "$dest")"

  if [ -L "$dest" ]; then
    if [ "$(readlink "$dest")" = "$src" ]; then
      # correct symlink — nothing to do
      log_ok "$dest (already linked)"
      return 0
    else
      # wrong target — remove and re-symlink
      log_info "$dest points to wrong target — relinking"
      rm "$dest"
    fi
  fi

  # exists but is a real file — move it aside. The time in the name keeps an
  # older backup from being overwritten by a newer one.
  if [ -e "$dest" ]; then
    local backup="$dest.bak.$(date +%Y%m%d-%H%M%S)"
    mv "$dest" "$backup"
    log_info "existing file kept as: $backup"
  fi

  ln -sf "$src" "$dest"
  log_ok "linked: $dest"
}

# unlink_dot <path> — undo a symlink() call.
# Only removes a symlink that points into this repo. Real files, and links to
# anywhere else, are left alone. If symlink() moved an existing file aside as
# <path>.bak.<time>, the newest of those is put back.
unlink_dot() {
  local dest="${1/#\~/$HOME}"
  local target

  if [ ! -L "$dest" ]; then
    if [ -e "$dest" ]; then
      log_warn "$dest is a real file, not a link — left alone"
    else
      log_info "$dest not there — skipping"
    fi
    return 0
  fi

  target="$(readlink "$dest")"
  case "$target" in
    "$DOTS"/*) ;;
    *)
      log_warn "$dest points outside the dotfiles ($target) — left alone"
      return 0
      ;;
  esac

  rm "$dest"
  log_ok "unlinked: $dest"

  # names sort by time, so the last match is the newest backup
  # (a plain .bak is what symlink() used to make)
  local backup newest=""
  for backup in "$dest.bak" "$dest.bak."*; do
    [ -e "$backup" ] && newest="$backup"
  done
  if [ -n "$newest" ]; then
    mv "$newest" "$dest"
    log_ok "restored: $dest (from ${newest##*/})"
  fi
}
