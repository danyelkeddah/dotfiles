return {
    'mfussenegger/nvim-lint',
    enabled = true,
    lazy = true,
    events = { 'BufWritePost', 'BufReadPost', 'InsertLeave' },
    config = function()
        local lint = require('lint')

        lint.linters_by_ft = {
            javascript = { 'eslint_d' },
            typescript = { 'eslint_d' },
            javascriptreact = { 'eslint_d' },
            typescriptreact = { 'eslint_d' },
            dockerfile = { 'hadolint' },
            markdown = { 'markdownlint' },
            terraform = { 'terraform_validate' },
            tf = { 'terraform_validate' },
            ['*'] = { 'typos' },
        }

        local lint_augroup = vim.api.nvim_create_augroup('nvim-lint', { clear = true })

        vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufReadPost', 'InsertLeave' }, {
            group = lint_augroup,
            callback = function()
                print('linting...')
                lint.try_lint()
                print('finish linting...')
            end,
        })

        -- vim.keymap.set('n', '<leader>cl', function()
        --     lint.try_lint()
        -- end, { desc = '[C]ode [L]int' })
    end,
}
