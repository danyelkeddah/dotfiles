local splitjoin = require('mini.splitjoin')
local pad_curly = splitjoin.gen_hook.pad_brackets({ brackets = { '%b{}' } })

splitjoin.setup({
    join = {
        hooks_post = { pad_curly },
    },
})
