#!/usr/bin/env bash

log_info "syncing anthropic api key secret"
upsert_secret "ANTHROPIC_API_KEY" "$(op read "op://Personal/d5qqmscjtlpcsv5e5uxhgfbeb4/anthropic - personal token")"
log_ok "anthropic api secret synced"
