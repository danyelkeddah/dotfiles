#!/usr/bin/env bash

# pnpm keeps its global config in a different place on each OS
case "$DOT_OS" in
  macos) CONFIG="$HOME/Library/Preferences/pnpm/config.yaml" ;;
  *)     CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/pnpm/config.yaml" ;;
esac

install() {
  if command -v pnpm >/dev/null; then
    log_ok "pnpm (already installed)"
  else
    # The standalone installer needs no Node.js.
    # https://pnpm.io/installation
    log_info "installing pnpm via standalone installer..."
    curl -fsSL https://get.pnpm.io/install.sh | sh -
    log_warn "installer ran \`pnpm setup\` and appended PNPM_HOME exports to your shell rc;"
    log_warn "path.zsh already manages this — review and discard duplicates with \`git -C \$DOTS status\`."
  fi

  symlink "$DOTS/pnpm/config/config.yaml" "$CONFIG"
}

upgrade() {
  pnpm self-update
}

remove() {
  unlink_dot "$CONFIG"
}
