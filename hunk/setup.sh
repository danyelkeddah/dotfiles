#!/usr/bin/env bash
DEPS=(pnpm)

install() {
  if command -v hunk >/dev/null; then
    log_ok "hunk (already installed)"
  else
    log_info "installing hunk..."
    pnpm add -g hunkdiff
  fi
}

configure() {
  symlink "$DOTS/hunk/config/config.toml" "$HOME/.config/hunk/config.toml"
}

upgrade() {
  pnpm add -g hunkdiff@latest
}

unconfigure() {
  unlink_dot "$HOME/.config/hunk/config.toml"
}

uninstall() {
  pnpm remove -g hunkdiff
}
