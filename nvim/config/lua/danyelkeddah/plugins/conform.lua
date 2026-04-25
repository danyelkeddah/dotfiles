require('conform').setup({
    formatters_by_ft = {
        javascript = { 'eslint_d', 'prettier' },
        typescript = { 'eslint_d', 'prettier' },
        javascriptreact = { 'eslint_d', 'prettier' },
        typescriptreact = { 'eslint_d', 'prettier' },
        css = { 'prettier' },
        html = { 'prettier' },
        json = { 'prettier' },
        -- yaml = { 'prettier' },
        markdown = { 'prettier' },
        lua = { 'stylua' },
        hcl = { 'terraform_fmt' },
        php = { 'pint' },
        terraform = { 'terraform_fmt' },
        tf = { 'terraform_fmt' },
        ['terraform-vars'] = { 'terraform_fmt' },
        go = { 'goimports', 'gofumpt' },
    },
    format_on_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
        end
        return { timeout_ms = 1000, lsp_format = 'never' }
    end,
    default_format_opts = {
        lsp_format = 'never',
    },
})

vim.api.nvim_create_user_command('FormatDisable', function(args)
    if args.bang then
        vim.b.disable_autoformat = true
    else
        vim.g.disable_autoformat = true
    end
end, { desc = 'Disable autoformat-on-save (use ! for buffer-local)', bang = true })

vim.api.nvim_create_user_command('FormatEnable', function()
    vim.b.disable_autoformat = false
    vim.g.disable_autoformat = false
end, { desc = 'Re-enable autoformat-on-save' })

vim.keymap.set({ 'n', 'v' }, '<leader>cf', function()
    require('conform').format({ async = true })
end, { desc = 'Format' })
