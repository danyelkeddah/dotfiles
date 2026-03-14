#!/usr/bin/env bash

log_info "removing anthropic api key secret..."
remove_secret "ANTHROPIC_API_KEY"
log_ok "anthropic secret removed"
