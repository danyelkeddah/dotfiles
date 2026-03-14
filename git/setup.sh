#!/usr/bin/env bash

DEPS=(homebrew)

if is_macos; then

  if ! command -v git &>/dev/null; then
    log_info "installing git tools..."
    brew install git diff-so-fancy lazygit git-quick-stats
  else
    log_info "git already installed — skipping"
  fi


  if ! ssh-keygen -F github.com &>/dev/null; then
    log_info "adding github.com to known hosts..."
    mkdir -p "$HOME/.ssh"
    ssh-keyscan -t rsa github.com >> "$HOME/.ssh/known_hosts"
    log_ok "github.com added to known hosts"
  else
    log_info "github.com already in known hosts — skipping"
  fi
fi

log_info "symlinking git templates..."
symlink "$DOTS/git/config/templates" "$HOME/.config/git/templates"

log_info "configuring git..."

git config --global user.name                             "Danyel Alkeddah"
git config --global user.username                         "danyelkeddah"
git config --global user.email                            "14123621+danyelkeddah@users.noreply.github.com"
git config --global user.signingkey                       "$HOME/.ssh/id_ed25519.pub"
git config --global init.defaultBranch                    main
git config --global gpg.format                            ssh
git config --global gpg.ssh.program                       "/Applications/1Password.app/Contents/MacOS/op-ssh-sign"
git config --global gpg.ssh.allowedSignersFile            "$HOME/.config/git/allowed_signers"
git config --global core.editor                           nvim
git config --global core.excludesfile                     "$HOME/.config/git/templates/gitignore_global"
git config --global core.pager                            "diff-so-fancy | less --tabs=4 -RFX"
git config --global fetch.prune                           true
git config --global push.autoSetupRemote                  true
git config --global commit.gpgsign                        true
git config --global commit.template                       "$HOME/.config/git/templates/gitmessage"
git config --global pull.rebase                           true
git config --global "url.ssh://git@github.com/.insteadOf" "https://github.com/"
