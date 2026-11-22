#!/usr/bin/env bash
# gum draws dot's own picker, yes/no questions and summary table

install() {
  case "$DOT_PKG" in
    apt)
      # not in Debian/Ubuntu's own repos — comes from Charm's
      pkg_installed gum \
        || apt_add_repo charm https://repo.charm.sh/apt/gpg.key "https://repo.charm.sh/apt/ * *"
      pkg_install gum
      ;;
    dnf)
      log_warn "gum on Fedora needs Charm's yum repo, which this package doesn't set up"
      log_warn "see https://github.com/charmbracelet/gum#installation"
      ;;
    *)
      pkg_install gum
      ;;
  esac
}
