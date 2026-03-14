return {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    keys = {
        {
            '<leader>?',
            function()
                require('which-key').show({ global = false })
            end,
            desc = 'Buffer Local Keymaps (which-key)',
        },
    },
    opts = {
        preset = 'helix',
        plugins = { spelling = true },
        spec = {
            {
                mode = { 'n', 'v' },
                { ']', name = 'next' },
                { '[', name = 'prev' },
                { 'g', name = 'goto' },
                { 'gs', name = 'surround' },
                { 'z', name = 'fold' },
                -- ['<leader><tab>'] = { name = 'tabs' },
                { '<leader>b', name = 'buffer' },
                { '<leader>c', name = 'code' },
                { '<leader>f', name = 'file/find' },
                { '<leader>g', name = 'git' },
                { '<leader>gh', name = 'hunks' },
                { '<leader>q', name = 'quit/session' },
                { '<leader>s', name = 'search' },
                -- ['<leader>t'] = { name = 'test' },
                { '<leader>u', name = 'ui' },
                { '<leader>w', name = 'windows' },
                { '<leader>x', name = 'diagnostics/quickfix' },
            },
        },
    },
}
