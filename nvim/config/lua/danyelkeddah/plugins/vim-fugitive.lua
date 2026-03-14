return {
    'tpope/vim-fugitive',
    dependencies = { 'tpope/vim-rhubarb' },
    lazy = false,
    keys = {
        -- { '<leader>gs', vim.cmd.Git, desc = 'Git status' },
        -- { '<leader>gb', ':GBrowse<CR>', desc = 'Git browse' },
        -- { mode = 'v', '<leader>gb', ":'<,'>gbrowse<cr>", desc = 'get browse' },
        -- { '<leader>gP', ':Git push<cr>', desc = 'get push' },
        -- { '<leader>gp', ':Git pull<cr>', desc = 'get pull' },
    },
    -- stylua: ignore
    config = function()
        vim.keymap.set('n', '<leader>gs', '<cmd>Git<cr>', { desc = 'Git status' })
        vim.keymap.set('v', '<leader>gb', "<cmd>'<,'>GBrowse<cr>", { desc = 'Git pull' })
        vim.keymap.set('n', '<leader>gP', '<cmd>Git push<cr>', { desc = 'Git push' })
        vim.keymap.set('n', '<leader>gp', '<cmd>Git pull<cr>', { desc = 'Git pull' })

        vim.api.nvim_create_autocmd('Filetype', {
            pattern = 'fugitive',
            group = vim.api.nvim_create_augroup('FugitiveOpen', { clear = true }),
            callback = function()
                vim.cmd.normal('gg]]')
            end,
        })
    end,
}
