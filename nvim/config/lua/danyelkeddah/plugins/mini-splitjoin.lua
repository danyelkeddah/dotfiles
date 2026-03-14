return {
    'echasnovski/mini.splitjoin',
    version = '*',
    config = function()
        local splitjoin = require('mini.splitjoin')
        local curly = { brackets = { '%b{}' } }
        local pad_curly = splitjoin.gen_hook.pad_brackets(curly)
        splitjoin.setup({ join = {
            hooks_post = { pad_curly },
        } })
    end,
}
