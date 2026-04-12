# Global aliases — shorthand that expands anywhere in a command
# e.g. "cat file.log NE" expands to "cat file.log 2>/dev/null"

# Suppress stderr (e.g. "cmd NE" → "cmd 2>/dev/null")
alias -g NE='2>/dev/null'

# Suppress stdout (e.g. "cmd NO" → "cmd >/dev/null")
alias -g NO='>/dev/null'

# Suppress all output (e.g. "cmd NUL" → "cmd >/dev/null 2>&1")
alias -g NUL='>/dev/null 2>&1'

# Pipe into jq for JSON pretty-printing (e.g. "curl url JQ" → "curl url | jq")
command -v jq &>/dev/null && alias -g JQ='| jq'

# Copy output to clipboard via pbcopy (e.g. "pwd C" → "pwd | pbcopy")
command -v pbcopy &>/dev/null && alias -g C='| pbcopy'
