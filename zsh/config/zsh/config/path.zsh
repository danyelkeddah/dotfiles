# Note: /opt/homebrew/bin and /opt/homebrew/sbin are added automatically
# by macOS via /usr/libexec/path_helper (reads from /etc/paths.d/)

# Ensure Homebrew system paths are available (Intel Mac locations)
[ -d "/usr/local/sbin" ] && export PATH=/usr/local/sbin:$PATH
[ -d "/usr/local/bin" ] && export PATH=/usr/local/bin:$PATH

# PHP Composer — globally installed packages (e.g. phpstan, laravel installer)
[ -d "$HOME/.composer/vendor/bin" ] && export PATH=$HOME/.composer/vendor/bin:$PATH

# Node — globally installed packages via npm/yarn
[ -d "$HOME/.node/bin" ] && export PATH=$HOME/.node/bin:$PATH

# Project-local binaries — disabled due to security risk (relative paths resolve from cwd)
# Use npx for Node or ./vendor/bin/ for PHP instead
# export PATH=node_modules/.bin:vendor/bin:$PATH

# User scripts and binaries (~/.local/bin is the XDG convention, ~/bin is the legacy fallback)
[ -d "$HOME/bin" ] && export PATH=$HOME/bin:$PATH
[ -d "$HOME/.local/bin" ] && export PATH=$HOME/.local/bin:$PATH

# Go — workspace for packages and compiled binaries, uses go env for portability across platforms
export GOPATH="$HOME/.go"
if command -v go &>/dev/null; then
  export GOROOT="$(go env GOROOT)"
  export PATH=$PATH:$GOROOT/bin
fi
[ -d "$GOPATH/bin" ] && export PATH=$PATH:$GOPATH/bin

# pnpm — fast Node package manager, stores global binaries under ~/.local/share/pnpm
export PNPM_HOME="${HOME}/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac

# fzf — open selected file in VS Code with ctrl-o
export FZF_DEFAULT_OPTS="--bind='ctrl-o:execute(code {})+abort'"
