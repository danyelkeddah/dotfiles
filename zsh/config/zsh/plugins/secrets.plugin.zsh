# Secrets are not kept in the shell's environment. A command that needs them
# gets them from 1Password when it starts, and only that process sees them.
#
#   with-secrets <command> [args...]
#
# The names and their 1Password references are in $ZSH/secrets.refs.
# Needs the 1Password CLI (op). On a desktop, turn on
# "Integrate with 1Password CLI" in 1Password > Settings > Developer.
#
# If 1Password can't supply them here (no op, not signed in, or this account
# can't see the vault), the command still runs, just without the secrets.
with-secrets() {
  local resolved line

  if ! command -v op >/dev/null; then
    print -u2 "with-secrets: 1Password CLI (op) not found — running without secrets"
    command "$@"
    return
  fi
  # op inject prints the file with every reference replaced by its value
  if ! resolved="$(op inject -i "$ZSH/secrets.refs" 2>/dev/null)"; then
    print -u2 "with-secrets: 1Password could not read the secrets here — running without them"
    command "$@"
    return
  fi

  # a subshell, so the values never reach this shell
  (
    while IFS= read -r line; do
      [[ $line == [A-Za-z_]*=* ]] || continue          # skip comments and blanks
      line="${line%%=*}=${${${line#*=}#\"}%\"}"        # NAME="value" → NAME=value
      export "$line"
    done <<< "$resolved"
    command "$@"
  )
}

# commands that need a key
pi() { with-secrets pi "$@" }
