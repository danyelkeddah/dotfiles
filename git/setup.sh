#!/usr/bin/env bash

DEPS=(homebrew packages)

if ! command -v git &>/dev/null; then
  log_info "installing git..."
  if is_macos;    then brew install git
  elif is_arch;   then sudo pacman -S --needed --noconfirm git
  elif is_ubuntu; then sudo apt install -y git
  fi
  else
  log_info "git already installed — skipping"
fi

if ! command -v diff-so-fancy &>/dev/null; then
  log_info "installing diff-so-fancy..."
  if is_macos;    then brew install diff-so-fancy
  elif is_arch;   then yay -S --needed --noconfirm diff-so-fancy
  elif is_ubuntu; then
    sudo add-apt-repository -y ppa:aos1/diff-so-fancy
    sudo apt update
    sudo apt install diff-so-fancy
  fi
else
  log_info "diff-so-fancy already installed — skipping"
fi

if ! command -v lazygit &>/dev/null; then
  log_info "installing lazygit..."
  if is_macos;    then brew install lazygit
  elif is_arch;   then yay -S --needed --noconfirm lazygit
  elif is_ubuntu; then
    lazygit_version=$(curl -fsSL https://api.github.com/repos/jesseduffield/lazygit/releases/latest \
      | grep '"tag_name"' | sed 's/.*"v\(.*\)".*/\1/')
    curl -fLo /tmp/lazygit.tar.gz \
      "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${lazygit_version}_Linux_x86_64.tar.gz"
    tar -xf /tmp/lazygit.tar.gz -C /tmp lazygit
    sudo mv /tmp/lazygit /usr/local/bin/lazygit
  fi
else
  log_info "lazygit already installed — skipping"
fi

if ! command -v git-quick-stats &>/dev/null; then
  log_info "installing git-quick-stats..."
  if is_macos;    then brew install git-quick-stats
  elif is_arch;   then yay -S --needed --noconfirm git-quick-stats
  elif is_ubuntu; then
    curl -fLo /tmp/git-quick-stats \
      "https://raw.githubusercontent.com/arzzen/git-quick-stats/master/git-quick-stats"
    sudo mv /tmp/git-quick-stats /usr/local/bin/git-quick-stats
    sudo chmod +x /usr/local/bin/git-quick-stats
  fi
else
  log_info "git-quick-stats already installed — skipping"
fi

if ! ssh-keygen -F github.com &>/dev/null; then
  log_info "adding github.com to known hosts..."
  mkdir -p "$HOME/.ssh"
  ssh-keyscan -t rsa github.com >> "$HOME/.ssh/known_hosts"
  log_ok "github.com added to known hosts"
else
  log_info "github.com already in known hosts — skipping"
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
