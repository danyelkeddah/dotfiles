export CLICOLOR=1

# Help CLI/TUI apps detect truecolor correctly on capable terminals.
# Keep conditional so this cross-system config does not lie on older/basic terms.
case "$TERM" in
  xterm-ghostty|xterm-256color|tmux-256color|screen-256color)
    export COLORTERM=truecolor
    ;;
esac

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export MANPAGER="nvim +Man!"

# Load theme
source $ZSH/themes/robbyrussell-simple.zsh-theme

### ---- history config -------------------------------------
export HISTFILE=$HOME/.zsh_history

# How many commands zsh will load to memory.
export HISTSIZE=10000

# How many commands history will save on file.
export SAVEHIST=$HISTSIZE

# remove any duplicates in history file
export HISTDUP=erase

# append commands to history file
setopt appendhistory

# share history across all zsh sessions
setopt appendhistory

# prevent command from being written to history by adding space before
setopt hist_ignore_space

# History won't save duplicates.
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_FIND_NO_DUPS


# Fix some TMUX key bindings
bindkey '^R' history-incremental-search-backward
bindkey '^P' history-search-backward
bindkey '^N' history-search-forward

# Edit current command line in $EDITOR with ctrl-x ctrl-e
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line

# Expand history references (e.g. !!, !$) inline when pressing space
bindkey ' ' magic-space

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
# NOTE: don't use escape sequences here, fzf-tab will ignore them
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
zstyle ':completion:*' menu no
# preview directory's content with eza when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
# switch group using `<` and `>`
zstyle ':fzf-tab:*' switch-group '<' '>'

