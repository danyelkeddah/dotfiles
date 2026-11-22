#!/usr/bin/env bash
# gh itself is installed by mise; this package adds my extension
DEPS=(mise)

install() {
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

uninstall() {
  gh extension remove dlvhdr/gh-dash
}
