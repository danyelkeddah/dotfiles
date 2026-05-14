#!/usr/bin/env bash

# Standalone installer works on macOS (Apple Silicon) and Linux (glibc 2.27+)
# without requiring Node.js. Windows isn't covered — use the PowerShell
# installer or winget there. Self-update an existing install with `pnpm self-update`.
# https://pnpm.io/installation

if ! command -v pnpm &>/dev/null; then
  log_info "installing pnpm via standalone installer..."
  curl -fsSL https://get.pnpm.io/install.sh | sh -
  log_warn "installer ran \`pnpm setup\` and appended PNPM_HOME exports to your shell rc;"
  log_warn "path.zsh already manages this — review and discard duplicates with \`git -C \$DOTS status\`."
else
  log_info "pnpm already installed — skipping (run \`pnpm self-update\` to update)"
fi

# Global config lives under different paths per OS in pnpm 11.
log_info "symlinking pnpm config..."
if is_macos; then
  symlink "$DOTS/pnpm/config/config.yaml" "$HOME/Library/Preferences/pnpm/config.yaml"
else
  symlink "$DOTS/pnpm/config/config.yaml" "${XDG_CONFIG_HOME:-$HOME/.config}/pnpm/config.yaml"
fi
