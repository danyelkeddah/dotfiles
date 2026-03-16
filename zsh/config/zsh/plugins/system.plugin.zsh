alias ssh='env TERM=xterm-256color ssh'

alias c="clear"
alias o="open ."
alias sizes='du -sh -c *'

# Copy pwd to clipboard
alias cwd="pwd && pwd | pbcopy && echo 'Copied to clipboard 📁'"

# TODO: Move this to k8s.plugins.zsh
alias k="kubectl" 

if command -v trash &>/dev/null; then
  rm() { trash "$@"; }
  rf() { trash -rf "$@"; }
else
  log_warn "trash not installed — using system rm (no recovery possible)"
  rf() { command rm -rf "$@"; }
fi

