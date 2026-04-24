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
        -- formatters / linters
        'prettier',
        'stylua',
        'eslint_d',
        'ansible-lint',
        'pint',
        'hadolint',
        'goimports',
        'gofumpt',
        'markdownlint',
        'typos',
        'hclfmt',
        -- language servers
        'ansible-language-server',
        'css-lsp',
        'dockerfile-language-server',
        'docker-compose-language-service',
        'emmet-ls',
        'gopls',
        'html-lsp',
        'intelephense',
        'json-lsp',
        'lua-language-server',
        'marksman',
        'tailwindcss-language-server',
        'terraform-ls',
        'typescript-language-server',
        'yaml-language-server',
    },
})

vim.keymap.set('n', '<leader>cm', '<cmd>Mason<cr>', { desc = 'Mason' })
