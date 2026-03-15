#!/usr/bin/env bash

log_info "removing intelephense license..."
rm -f "$HOME/.config/intelephense/licence.txt"
log_ok "intelephense license removed"
