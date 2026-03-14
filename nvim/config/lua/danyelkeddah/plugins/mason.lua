local icons = require('danyelkeddah.icons')

local M = {}

table.insert(M, {
    'williamboman/mason.nvim',
    config = function()
        local mason = require('mason')
        mason.setup({
            max_concurrent_installers = 10,
            ui = {
                icons = icons.mason,
                height = 0.7,
                border = 'rounded',
            },
            keymaps = {
                toggle_server_expand = '<CR>',
                install_server = 'i',
                update_server = 'u',
                check_server_version = 'c',
                update_all_servers = 'U',
                check_outdated_servers = 'C',
                uninstall_server = 'X',
                cancel_installation = '<C-c>',
            },
        })
        vim.keymap.set('n', '<leader>cm', '<cmd>Mason<cr>', { desc = 'Mason' })
    end,
})

table.insert(M, {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    dependencies = {
        'williamboman/mason.nvim',
        { 'j-hui/fidget.nvim', opts = { notification = { window = { winblend = 0 } } } },
    },
    config = function()
        local mason_tool_installer = require('mason-tool-installer')
        mason_tool_installer.setup({
            ensure_installed = {
                'prettier',
                'stylua',
                'eslint_d',
                'ansible-lint',
                'pint',
                'hadolint',
                'goimports',
                'gofumpt',
                'markdownlint',
                'marksman',
                'typos',
                'hclfmt',
            },
        })
    end,
})

return M
