alias g="git"
alias gl="git log --oneline --decorate --color"
alias glt='git describe --tags --abbrev=0'
alias gpull="git pull"
alias gpush="git push"
alias gpr="git pull --rebase"
alias gadd="git add ."
alias commit="git add . && git commit -m"
alias gca="git add . && git commit -av"
alias wip="commit 'WIP 👷‍♂️'"
# alias commit="git add . && git commit"
# alias mcommit="git add . && git commit -m"
# alias gs="git status"

gs() {
  if [ -n "$1" ]; then z $1; fi

  if git rev-parse --git-dir > /dev/null 2>&1; then
    $EDITOR '+Gedit :'
  else
    git status
  fi
}

# commit() {
#   git commit -m "$*"
# }

gco() {
  if [ -n "$1" ]; then git checkout $1; return; fi
  git branch -vv | fzf | awk '{print $1}' | xargs git checkout
}

gbd() {
  if [ -n "$1" ]; then git branch -d $1; return; fi
  local selected=$(git branch -vv | fzf | awk '{print $1}' | sed "s/.* //")
  if [ -z "$selected" ]; then return; fi
  echo "Are you sure you would like to delete branch [\e[0;31m$selected\e[0m]? (Type 'delete' to confirm)"
  read confirmation
  if [[ "$confirmation" == "delete" ]]; then
    git branch -D $selected
  fi
}


# Discard all unstaged changes & untracked files to trash bin
# Note: This requires `trash` util so that the files can be restored if needed later
nah() {
  echo "Are you sure you would like to discard/delete all unstaged changes & untracked files? (Type 'y' to confirm)"
  read confirmation
  if [[ "$confirmation" == "y" ]]; then
    git ls-files --modified --other --exclude-standard | xargs trash -rf
    git reset --hard
    git clean -qf
  fi
}
