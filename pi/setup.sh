#!/usr/bin/env bash

DEPS=(pnpm)

if ! command -v pi &>/dev/null; then
  log_info "installing pi agent..."
  pnpm add -g --ignore-scripts @earendil-works/pi-coding-agent
else
  log_info "pi already installed — skipping"
fi
