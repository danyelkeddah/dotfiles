require('mason').setup({
    max_concurrent_installers = 10,
    ui = {
        height = 0.7,
        border = 'rounded',
        icons = {
            package_installed = '󰄳 ',
            package_pending = ' ',
            package_uninstalled = '󰚌 ',
        },
    },
})

require('mason-tool-installer').setup({
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

vim.keymap.set('n', '<leader>cm', '<cmd>Mason<cr>', { desc = 'Mason' })
