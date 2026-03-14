#!/usr/bin/env bash

log_info "removing allowed_signers..."
rm -f "$HOME/.config/git/allowed_signers"
log_ok "allowed_signers removed"
