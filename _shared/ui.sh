#!/usr/bin/env bash
# _shared/ui.sh
#
# Everything dot prints or asks.
#
# Lines (log_*) are plain printf with colour: no extra process per line, and
# they look the same whether or not gum is installed.
#
# gum is used only where it does something printf can't — the package picker,
# yes/no questions and the summary table — and each of those has a plain
# fallback, so dot works before gum is installed, in CI and when piped.
#
#   UI_COLOR  1 when output is a terminal and NO_COLOR is unset
#   UI_ASK    1 when there is a person to ask (stdin and stdout are terminals)
#   UI_GUM    1 when gum can be used for the interactive parts

UI_COLOR=""
UI_ASK=""
UI_GUM=""
[ -t 1 ] && [ -z "${NO_COLOR:-}" ] && UI_COLOR=1
[ -t 0 ] && [ -t 1 ] && UI_ASK=1
[ -n "$UI_ASK" ] && [ -n "$UI_COLOR" ] && [ -z "${CI:-}" ] \
  && command -v gum >/dev/null 2>&1 && UI_GUM=1

if [ -n "$UI_COLOR" ]; then
  UI_BLUE=$'\033[1;34m' UI_GREEN=$'\033[1;32m' UI_RED=$'\033[1;31m'
  UI_CYAN=$'\033[1;36m' UI_YELLOW=$'\033[1;33m' UI_DIM=$'\033[2m' UI_OFF=$'\033[0m'
else
  UI_BLUE="" UI_GREEN="" UI_RED="" UI_CYAN="" UI_YELLOW="" UI_DIM="" UI_OFF=""
fi

# width of the header rule: the terminal's, but never wider than 72
UI_WIDTH="$(tput cols 2>/dev/null || echo 72)"
[ "$UI_WIDTH" -gt 72 ] 2>/dev/null && UI_WIDTH=72
[ "$UI_WIDTH" -ge 20 ] 2>/dev/null || UI_WIDTH=72

export UI_COLOR UI_ASK UI_GUM UI_WIDTH \
  UI_BLUE UI_GREEN UI_RED UI_CYAN UI_YELLOW UI_DIM UI_OFF

# ── Lines ─────────────────────────────────────────────────────────────────────

# ━━ tmux ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
log_header() {
  local rule="" n=$((UI_WIDTH - ${#1} - 4))
  while [ "$n" -gt 0 ]; do rule="$rule━"; n=$((n - 1)); done
  printf '\n%s━━ %s %s%s\n' "$UI_BLUE" "$1" "$rule" "$UI_OFF"
}

log_ok()   { printf '%s  ✓ %s%s\n' "$UI_GREEN"  "$1" "$UI_OFF"; }
log_err()  { printf '%s  ✗ %s%s\n' "$UI_RED"    "$1" "$UI_OFF"; }
log_info() { printf '%s  → %s%s\n' "$UI_CYAN"   "$1" "$UI_OFF"; }
log_warn() { printf '%s  ⚠ %s%s\n' "$UI_YELLOW" "$1" "$UI_OFF"; }

# ── Questions ─────────────────────────────────────────────────────────────────

# ui_confirm <question> — yes/no. With nobody to ask, the answer is yes:
# a script or CI job that ran the command meant it.
ui_confirm() {
  local answer
  [ -n "$UI_ASK" ] || return 0
  if [ -n "$UI_GUM" ]; then
    gum confirm "$1"
    return
  fi
  printf '%s [y/N] ' "$1" >&2   # stderr: stdout may be captured
  read -r answer
  [[ "$answer" == [yY]* ]]
}

# ui_choose <title> <item>... — pick any number of items; everything starts
# selected. Type to search, Tab to toggle, Enter to confirm, Ctrl+C to cancel.
# Prints the chosen items, one per line. Fails if cancelled or nothing was
# chosen, and says so itself (on stderr — stdout carries the answer).
# Without gum there is no picker: it is all or nothing.
#
# (gum filter rather than gum choose: choose has no search. Space can't be the
# toggle key here — it is a character you can type into the search box.)
ui_choose() {
  local title="$1" chosen item rc=0
  shift
  if [ -n "$UI_GUM" ]; then
    chosen="$(gum filter --no-limit --selected='*' --height=20 \
      --header "$title" --placeholder "type to search..." "$@")" || rc=$?
    # Esc (exit 1): gum prints "nothing selected" itself. Ctrl+C (exit 130): it
    # prints nothing, so we do. Either way exactly one line is shown.
    [ "$rc" = 1 ] && return 1
    if [ "$rc" != 0 ] || [ -z "$chosen" ]; then
      log_info "nothing selected" >&2
      return 1
    fi
    # gum returns items in the order they were toggled; put them back in the
    # order they were given, which is the order they must run in
    for item in "$@"; do
      [[ $'\n'"$chosen"$'\n' == *$'\n'"$item"$'\n'* ]] && echo "$item"
    done
    return 0
  fi
  if ! ui_confirm "$title — all $# of them?"; then
    log_info "nothing selected" >&2
    return 1
  fi
  printf '%s\n' "$@"
}

# ── Summary ───────────────────────────────────────────────────────────────────

# ui_summary — reads lines of "name|status|seconds" on stdin.
# status: ok | failed | skipped
ui_summary() {
  local name status secs mark colour

  if [ -n "$UI_GUM" ]; then
    {
      echo "package,result,time"
      while IFS='|' read -r name status secs; do
        case "$status" in
          ok)      mark="✓ done" ;;
          failed)  mark="✗ failed" ;;
          *)       mark="– skipped" ;;
        esac
        echo "$name,$mark,${secs}s"
      done
    } | gum table --print
    return
  fi

  while IFS='|' read -r name status secs; do
    case "$status" in
      ok)      mark="✓"; colour="$UI_GREEN" ;;
      failed)  mark="✗"; colour="$UI_RED" ;;
      *)       mark="–"; colour="$UI_DIM" ;;
    esac
    printf '%s  %s %-16s %-8s %ss%s\n' "$colour" "$mark" "$name" "$status" "$secs" "$UI_OFF"
  done
}
