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

vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufReadPost', 'InsertLeave' }, {
    group = vim.api.nvim_create_augroup('nvim-lint', { clear = true }),
    callback = function()
        lint.try_lint()
    end,
})

-- vim.keymap.set('n', '<leader>cl', function()
--     lint.try_lint()
-- end, { desc = '[C]ode [L]int' })
