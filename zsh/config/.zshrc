export ZSH=$HOME/.config/zsh
export DOTFILES=$HOME/.dotfiles

source $ZSH/config/path.zsh
source $ZSH/config/defaults.zsh

# Machine-only secrets that 1Password itself cannot hand out, such as the
# service account token that lets `op` work on a server. Never in this repo.
# Everything else comes from 1Password on demand: plugins/secrets.plugin.zsh
[ -f "$HOME/.secrets.zsh" ] && source "$HOME/.secrets.zsh"

# add completions (upstream first; custom is additive for tools upstream doesn't ship)
fpath=($ZSH/completions/src $ZSH/completions-custom $fpath)

# source plugins
source $ZSH/plugins/utils.plugin.zsh
source $ZSH/plugins/fzf-tab/fzf-tab.plugin.zsh
for file in $ZSH/plugins/*.plugin.zsh; do
    source "$file"
done

# build completions
autoload -U compinit && compinit

# mise — node, pnpm, rust, neovim and the other tools in mise/config/config.toml
# (path.zsh already put its shims on PATH, so the plugins above could see them;
# this switches to the real tool paths and per-directory versions)
command -v mise >/dev/null && eval "$(mise activate zsh)"

[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

# go — only where it is installed, and only if GOBIN is actually set
# (an empty entry in PATH means "the current directory")
export PATH="/usr/local/go/bin:$HOME/go/bin:$PATH"
if command -v go >/dev/null; then
  gobin="$(go env GOBIN)"
  [ -n "$gobin" ] && export PATH="$gobin:$PATH"
  unset gobin
fi
