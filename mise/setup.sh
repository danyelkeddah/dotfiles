#!/usr/bin/env bash
# mise installs the languages and command-line tools listed in
# config/config.toml — the same way on every OS, and without root.

# written on machines that cannot build php; see configure()
LOCAL="$HOME/.config/mise/config.local.toml"
LOCAL_MARK="# written by dot: php cannot be built on this machine"

# mise builds php from source. These are the libraries that build needs; the
# optional ones decide which extensions php ends up with (zip, gd, intl,
# pdo_pgsql, ...). Everything else mise installs is a ready-made download.
php_build_libs() {
  case "$DOT_PKG" in
    apt)
      pkg_install build-essential autoconf bison re2c pkg-config \
        libxml2-dev libssl-dev libicu-dev libzip-dev libonig-dev \
        libcurl4-openssl-dev libpng-dev libjpeg-dev libfreetype6-dev \
        libwebp-dev libgmp-dev libsodium-dev libreadline-dev libbz2-dev \
        libsqlite3-dev zlib1g-dev libpq-dev
      ;;
    brew)
      pkg_install autoconf bison re2c pkgconf \
        libxml2 openssl@3 icu4c zlib libzip oniguruma \
        freetype jpeg libpng webp gmp libsodium readline bzip2 libpq
      ;;
    pacman)
      pkg_install base-devel autoconf bison re2c pkgconf \
        libxml2 openssl icu libzip oniguruma curl libpng libjpeg-turbo \
        freetype2 libwebp gmp libsodium readline bzip2 sqlite zlib postgresql-libs
      ;;
  esac
}

install() {
  if command -v mise >/dev/null; then
    log_ok "mise (already installed)"
  else
    log_info "installing mise..."
    # the official installer puts a single binary in ~/.local/bin
    curl -fsSL https://mise.run | sh
  fi

  # node's official build needs this library, and minimal Debian/Ubuntu
  # installs don't have it
  [ "$DOT_PKG" = apt ] && pkg_install libatomic1

  php_build_libs
}

# The list of tools is the config, so putting the config in place also means
# installing what it lists. Quick when nothing is missing; run it again after
# editing the list.
configure() {
  symlink "$DOTS/mise/config/config.toml" "$HOME/.config/mise/config.toml"

  # Without root on Linux the libraries php's build needs can't be installed.
  # Rather than let that one build fail the whole list, php is switched off on
  # this machine only, in mise's machine-local config.
  if [ "$DOT_PKG" != brew ] && [ "$DOT_ROOT" = no ] && ! command -v re2c >/dev/null; then
    if [ ! -f "$LOCAL" ]; then
      printf '%s\n[settings]\ndisable_tools = ["php"]\n' "$LOCAL_MARK" > "$LOCAL"
    fi
    log_warn "php needs build libraries that only root can install — left out on this machine"
    log_warn "to try again later: delete $LOCAL and run \`dot configure mise\`"
  fi

  log_info "installing tools..."
  mise install --yes
}

upgrade() {
  log_info "updating mise..."
  mise self-update --yes
  log_info "upgrading tools..."
  mise upgrade --yes
}

unconfigure() {
  unlink_dot "$HOME/.config/mise/config.toml"
  # only if it is the file configure() wrote, not one of your own
  if grep -qF "$LOCAL_MARK" "$LOCAL" 2>/dev/null; then
    rm -f "$LOCAL"
    log_ok "removed $LOCAL"
  fi
}

# mise and every tool it installed
uninstall() {
  mise implode --yes
}

# ── one-off: remove what mise replaced ────────────────────────────────────────
#
#   dot run mise cleanup_old
#
# Earlier versions of these dotfiles installed many of these tools by other
# means (nvm, a git checkout of fzf, downloaded binaries, brew and apt
# packages). This removes those copies so only mise's remain. It shows what it
# found and asks before touching anything. Run it once per machine; when every
# machine has been through it, this function can be deleted.
cleanup_old() {
  local path name files="" root_files="" pkgs="" candidates="" tmux_running=""

  if ! mise which node >/dev/null 2>&1; then
    log_err "mise's tools are not installed yet — run \`dot mise\` first"
    return 1
  fi

  # ── what is there? ──────────────────────────────────────────────────────────
  for path in \
    "$HOME/.nvm" "$HOME/.fzf" "$HOME/.fzf.zsh" "$HOME/.fzf.bash" "$HOME/.opt/nvim" \
    "$HOME/.local/bin/nvim" "$HOME/.local/bin/k9s" "$HOME/.local/bin/lazygit" \
    "$HOME/.local/bin/just" "$HOME/.local/bin/bat"; do
    if [ -e "$path" ] || [ -L "$path" ]; then files="$files $path"; fi
  done

  for path in \
    /usr/local/bin/k9s /usr/local/bin/lazygit \
    /etc/apt/sources.list.d/charm.list /etc/apt/sources.list.d/github-cli.list \
    /etc/apt/keyrings/charm.gpg /etc/apt/keyrings/charm.asc /etc/apt/keyrings/github-cli.gpg \
    /usr/share/keyrings/githubcli-archive-keyring.gpg; do
    if [ -e "$path" ]; then root_files="$root_files $path"; fi
  done

  case "$DOT_PKG" in
    brew)
      candidates="awscli bat btop composer diff-so-fancy dive doctl duf fd fzf gh go gum helm
        jq just k9s kind kubernetes-cli kustomize lazygit minikube mkcert neovim node nvm
        ripgrep tree-sitter uv yq zoxide"
      ;;
    apt)
      candidates="bat btop composer diff-so-fancy fd-find fzf gh golang-go gum jq just neovim
        nodejs npm ripgrep yq zoxide"
      ;;
    pacman)
      candidates="bat btop composer diff-so-fancy fd fzf github-cli go gum jq just k9s lazygit
        neovim nodejs npm ripgrep tree-sitter-cli yq zoxide"
      ;;
  esac
  # The system's tmux goes too, but not while a tmux server is running: that
  # server was started by the old tmux, mise's newer one may not be able to
  # attach to it, and the old binary is then the only way back in.
  if ps -A -o comm= 2>/dev/null | grep -Eq '(^|/)tmux'; then
    pkg_installed tmux && tmux_running=1
  else
    candidates="$candidates tmux"
  fi

  for name in $candidates; do
    if pkg_installed "$name"; then pkgs="$pkgs $name"; fi
  done

  # said every time, whether or not anything else is left
  [ -n "$tmux_running" ] \
    && log_warn "the system's tmux is left in place while a tmux server is running — run this again after \`tmux kill-server\`"
  # The system's php is never removed here: web servers and background
  # services (apache, php-fpm, brew services) are wired to it, and mise's php
  # does not replace those. Your shell uses mise's php either way.
  for path in /usr/bin/php /usr/local/bin/php /opt/homebrew/bin/php; do
    if [ -x "$path" ]; then
      log_info "the system's php ($path) is left in place on purpose — services depend on it"
      break
    fi
  done

  if [ -z "$files$root_files$pkgs" ]; then
    log_ok "nothing else left over from older installs"
    return 0
  fi

  # ── show it and ask ─────────────────────────────────────────────────────────
  log_info "left over from older installs, now provided by mise:"
  for path in $files $root_files; do echo "      $path"; done
  [ -n "$pkgs" ] && echo "      $DOT_PKG packages:$pkgs"

  if [ -n "$DOT_YES" ]; then
    :
  elif [ -z "$UI_ASK" ]; then
    # ui_confirm answers yes when nobody is there; too generous for deleting
    log_warn "nobody to confirm with — nothing removed (pass -y to remove without asking)"
    return 0
  elif ! ui_confirm "Remove all of these?"; then
    log_info "nothing removed"
    return 0
  fi

  # ── remove ──────────────────────────────────────────────────────────────────
  for path in $files; do
    rm -rf "$path"
    log_ok "removed $path"
  done

  if [ -n "$root_files" ]; then
    if [ "$DOT_ROOT" = yes ]; then
      as_root rm -f $root_files
      log_ok "removed$root_files"
    else
      log_warn "no root access — left in place:$root_files"
    fi
  fi

  # asks again itself on apt and pacman, listing anything else that would go
  [ -n "$pkgs" ] && pkg_uninstall $pkgs

  # the key dot used to write here now comes from 1Password on demand
  # (plugins/secrets.plugin.zsh). Anything else in the file is yours and stays.
  if grep -q '^export ANTHROPIC_API_KEY=' "$HOME/.secrets.zsh" 2>/dev/null; then
    path="$(grep -v '^export ANTHROPIC_API_KEY=' "$HOME/.secrets.zsh" || true)"
    printf '%s\n' "$path" > "$HOME/.secrets.zsh"
    log_ok "removed ANTHROPIC_API_KEY from ~/.secrets.zsh"
  fi
}
