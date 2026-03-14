export ZSH=$HOME/.config/zsh
export DOTFILES=$HOME/.dotfiles

source $ZSH/config/path.zsh
source $ZSH/config/defaults.zsh

# add completions
fpath=($ZSH/completions/src $fpath)

source $HOME/.secrets.zsh

# source plugins
source $ZSH/plugins/fzf-tab/fzf-tab.plugin.zsh
for file in $ZSH/plugins/*.plugin.zsh; do
    source "$file"
done

# build completions
autoload -U compinit && compinit

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
