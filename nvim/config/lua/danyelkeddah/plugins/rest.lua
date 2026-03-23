return {
    'rest-nvim/rest.nvim',
    ft = 'http',
    build = false,
    dependencies = {
        'nvim-treesitter/nvim-treesitter',
        opts = function(_, opts)
            opts.ensure_installed = opts.ensure_installed or {}
            table.insert(opts.ensure_installed, 'http')
        end,
    },
    config = function(_, opts)
        -- stylua: ignore
        vim.api.nvim_create_autocmd('FileType', {
            pattern = 'http',
            callback = function()
                vim.keymap.set('n', '<leader>rr', '<cmd>:Rest run<cr>', { buffer = true, desc = 'Rest run' })
                vim.keymap.set('n', '<leader>rl', '<cmd>:Rest last<cr>', { buffer = true, desc = 'Rest last' })
                vim.keymap.set('n', '<leader>rL', '<cmd>:Rest logs<cr>', { buffer = true, desc = 'Rest logs' })
                vim.keymap.set('n', '<leader>rc', '<cmd>:Rest cookies<cr>', { buffer = true, desc = 'Rest cookies' })
                vim.keymap.set('n', '<leader>res', '<cmd>:Rest env select<cr>', { buffer = true, desc = 'Rest env select' })
                vim.keymap.set('n', '<leader>reS', '<cmd>:Rest env show<cr>', { buffer = true, desc = 'Rest env show' })
            end,
        })
    end,
}
