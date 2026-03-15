#!/usr/bin/env bash

log_info "syncing intelephense license from 1Password..."

mkdir -p "$HOME/.config/intelephense"
local license_file="$HOME/.config/intelephense/licence.txt"
local license_key
license_key=$(op read "op://Personal/Intelephense/license key")

if [ ! -f "$license_file" ]; then
  log_info "creating intelephense license file..."
  echo "$license_key" > "$license_file"
else
  log_info "intelephense license already exists — skipping"
fi

log_ok "intelephense license synced"
