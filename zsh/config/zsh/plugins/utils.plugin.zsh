# zsh/plugins/utils.plugin.zsh

log_header() { echo -e "\n\033[1;34m==> $1\033[0m"; }
log_ok()     { echo -e "\033[1;32m  ✓ $1\033[0m"; }
log_err()    { echo -e "\033[1;31m  ✗ $1\033[0m"; }
log_info()   { echo -e "\033[1;36m  → $1\033[0m"; }
log_warn()   { echo -e "\033[1;33m  ⚠ $1\033[0m"; }

is_macos()  { [[ "$(uname -s)" == "Darwin" ]]; }
is_arch()   { [[ -f /etc/arch-release ]]; }
is_ubuntu() { [[ -f /etc/debian_version ]]; }
