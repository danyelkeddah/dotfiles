#!/usr/bin/env bash

install() {
  # not in Debian/Ubuntu's own repos — comes from GitHub's
  if [ "$DOT_PKG" = apt ] && ! pkg_installed gh; then
    apt_add_repo github-cli \
      https://cli.github.com/packages/githubcli-archive-keyring.gpg \
      "https://cli.github.com/packages stable main"
  fi
  pkg_install gh pacman=github-cli

  command -v gh >/dev/null || return 0

  # extensions are downloaded through the API, which needs a login
  if ! gh auth status >/dev/null 2>&1; then
    log_warn "gh is not logged in — run \`gh auth login\`, then \`dot gh\` to add gh-dash"
  elif gh extension list | grep -q "dlvhdr/gh-dash"; then
    log_ok "gh-dash (already installed)"
  else
    log_info "installing gh-dash..."
    gh extension install dlvhdr/gh-dash
  fi
}

upgrade() {
  gh extension upgrade dlvhdr/gh-dash
}
