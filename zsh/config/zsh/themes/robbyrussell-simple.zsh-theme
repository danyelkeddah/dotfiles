autoload -U colors && colors
setopt prompt_subst

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[blue]%})%{$reset_color%} "

function git_branch_name()
{
  branch=$(git symbolic-ref --short HEAD 2> /dev/null)
  if [[ $branch == "" ]];
  then
    :
  else
    echo "${ZSH_THEME_GIT_PROMPT_PREFIX}$branch${ZSH_THEME_GIT_PROMPT_SUFFIX}"
  fi
}

function server_indicator()
{
  if [[ -n "$SSH_CLIENT" ]] || [[ -n "$SSH_TTY" ]] || [[ -n "$SSH_CONNECTION" ]]; then
    echo "%{$fg_bold[red]%}[REMOTE]%{$reset_color%} "
  fi
}
PROMPT='$(server_indicator)'
PROMPT+="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ ) %{$fg[cyan]%}%c%{$reset_color%}"
PROMPT+=' $(git_branch_name)'

