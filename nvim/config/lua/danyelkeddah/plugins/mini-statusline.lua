return {
    'echasnovski/mini.statusline',
    version = '*',
    dependencies = {
        'echasnovski/mini.icons',
    },
    config = function()
        require('mini.statusline').setup()
    end,
}
