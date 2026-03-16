if is_macos; then
  export HOMEBREW_NO_AUTO_UPDATE=1

  alias brews="brew services"
  alias brewu='brew update && brew upgrade && brew cleanup && brew prune && brew doctor'
fi
