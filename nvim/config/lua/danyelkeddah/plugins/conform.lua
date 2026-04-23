require('conform').setup({
    formatters_by_ft = {
        javascript = { 'prettier' },
        typescript = { 'prettier' },
        javascriptreact = { 'prettier' },
        typescriptreact = { 'prettier' },
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
    format_on_save = {
        timeout_ms = 500,
    },
})
