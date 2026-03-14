#!/usr/bin/env bash

log_info "syncing allowed_signers from 1Password..."
op read "op://Personal/Git/allowed_signers" \
  > "$HOME/.config/git/allowed_signers"
chmod 600 "$HOME/.config/git/allowed_signers"
log_ok "allowed_signers synced"
