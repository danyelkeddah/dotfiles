#!/usr/bin/env bash
if command -v fzf &>/dev/null && fzf --zsh &>/dev/null 2>&1; then
  eval "$(fzf --zsh)"
fi
