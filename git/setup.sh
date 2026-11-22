#!/usr/bin/env bash

BIN="$HOME/.local/bin"
SIGNERS="$HOME/.config/git/allowed_signers"

# the official release binary, into ~/.local/bin (needs no root)
lazygit_download() {
  local arch version tmp
  case "$DOT_ARCH" in
    x86_64) arch=x86_64 ;;
    arm64)  arch=arm64 ;;
    *)      log_err "no lazygit release for $DOT_ARCH"; return 1 ;;
  esac

  log_info "downloading lazygit..."
  version="$(curl -fsSL https://api.github.com/repos/jesseduffield/lazygit/releases/latest \
    | grep '"tag_name"' | sed 's/.*"v\(.*\)".*/\1/')"
  tmp="$(mktemp -d)"
  curl -fLo "$tmp/lazygit.tar.gz" \
    "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${version}_Linux_${arch}.tar.gz"
  tar -xf "$tmp/lazygit.tar.gz" -C "$tmp" lazygit
  mkdir -p "$BIN"
  mv "$tmp/lazygit" "$BIN/lazygit"
  rm -rf "$tmp"
}

# a single shell script, into ~/.local/bin
git_quick_stats_download() {
  log_info "downloading git-quick-stats..."
  mkdir -p "$BIN"
  curl -fLo "$BIN/git-quick-stats" \
    "https://raw.githubusercontent.com/arzzen/git-quick-stats/master/git-quick-stats"
  chmod +x "$BIN/git-quick-stats"
}

# can this machine log in to GitHub over SSH? (GitHub answers "successfully
# authenticated" and then closes the connection, so the exit code is no help)
github_ssh_works() {
  local answer
  command -v ssh >/dev/null || return 1
  # ssh exits 1 even on success here, hence `|| true` and reading the text
  answer="$(ssh -o BatchMode=yes -o ConnectTimeout=5 -T git@github.com 2>&1 || true)"
  [[ "$answer" == *"successfully authenticated"* ]]
}

install() {
  pkg_install git

  # ── diff-so-fancy ───────────────────────────────────────────────────────────
  # on apt it comes from a PPA, which only exists for Ubuntu
  if [ "$DOT_PKG" = apt ] && ! pkg_installed diff-so-fancy; then
    apt_add_ppa ppa:aos1/diff-so-fancy
  fi
  # (not fatal: without it git simply keeps its normal pager, see below)
  pkg_install diff-so-fancy || log_warn "diff-so-fancy could not be installed"

  # ── lazygit ─────────────────────────────────────────────────────────────────
  case "$DOT_PKG" in
    brew|pacman) pkg_install lazygit ;;
    *)
      if command -v lazygit >/dev/null; then
        log_ok "lazygit (already installed)"
      else
        lazygit_download
      fi
      ;;
  esac

  # ── git-quick-stats ─────────────────────────────────────────────────────────
  case "$DOT_PKG" in
    brew) pkg_install git-quick-stats ;;
    *)
      if command -v git-quick-stats >/dev/null; then
        log_ok "git-quick-stats (already installed)"
      else
        git_quick_stats_download
      fi
      ;;
  esac

  # ── known hosts ─────────────────────────────────────────────────────────────
  if ! command -v ssh-keygen >/dev/null; then
    log_warn "ssh is not installed — github.com not added to known hosts"
  elif ssh-keygen -F github.com >/dev/null 2>&1; then
    log_ok "github.com (already in known hosts)"
  else
    log_info "adding github.com to known hosts..."
    mkdir -p "$HOME/.ssh"
    ssh-keyscan -t rsa github.com >> "$HOME/.ssh/known_hosts"
  fi

  # ── config ──────────────────────────────────────────────────────────────────
  symlink "$DOTS/git/config/templates" "$HOME/.config/git/templates"

  log_info "configuring git..."
  git config --global user.name                             "Danyel Alkeddah"
  git config --global user.username                         "danyelkeddah"
  git config --global user.email                            "14123621+danyelkeddah@users.noreply.github.com"
  git config --global user.signingkey                       "$HOME/.ssh/id_ed25519.pub"
  git config --global init.defaultBranch                    main
  git config --global gpg.format                            ssh
  case "$DOT_OS" in
    macos) git config --global gpg.ssh.program "/Applications/1Password.app/Contents/MacOS/op-ssh-sign" ;;
    *)     git config --global gpg.ssh.program "ssh-keygen" ;;
  esac
  git config --global gpg.ssh.allowedSignersFile            "$SIGNERS"
  git config --global core.editor                           nvim
  git config --global core.excludesfile                     "$HOME/.config/git/templates/gitignore_global"
  # only where it exists — a pager that is missing breaks every git diff and log
  if command -v diff-so-fancy >/dev/null; then
    git config --global core.pager                          "diff-so-fancy | less --tabs=4 -RFX"
  else
    git config --global --unset-all core.pager || true
    log_warn "diff-so-fancy is not installed — git keeps its normal pager"
  fi
  git config --global fetch.prune                           true
  git config --global push.autoSetupRemote                  true
  git config --global commit.gpgsign                        true
  git config --global commit.template                       "$HOME/.config/git/templates/gitmessage"
  git config --global pull.rebase                           true

  # ── GitHub over SSH ─────────────────────────────────────────────────────────
  # Rewrite every GitHub https URL to SSH — but only where SSH to GitHub works.
  # On a machine without a key the rewrite would break every clone, including
  # the ones dot and nvim make.
  if github_ssh_works; then
    git config --global "url.ssh://git@github.com/.insteadOf" "https://github.com/"
    log_ok "GitHub URLs use SSH"
  else
    git config --global --unset-all "url.ssh://git@github.com/.insteadOf" || true
    log_warn "no GitHub SSH access here — GitHub URLs stay on https"
    log_warn "after adding a key, run: dot git"
  fi
}

upgrade() {
  # only the copies this package downloaded; packaged ones are upgraded by the system
  [ -x "$BIN/lazygit" ] && lazygit_download
  [ -x "$BIN/git-quick-stats" ] && git_quick_stats_download
  return 0
}

remove() {
  unlink_dot "$HOME/.config/git/templates"
}

sync_secrets() {
  log_info "syncing allowed_signers from 1Password..."
  local signers
  # read first: if 1Password fails, stop here rather than empty the file
  signers="$(op read "op://Personal/Git/allowed_signers")"
  mkdir -p "$(dirname "$SIGNERS")"
  printf '%s\n' "$signers" > "$SIGNERS"
  chmod 600 "$SIGNERS"
}

remove_secrets() {
  rm -f "$SIGNERS"
  log_ok "allowed_signers removed"
}
