local lint = require('lint')

lint.linters_by_ft = {
    javascript = { 'eslint_d' },
    typescript = { 'eslint_d' },
    javascriptreact = { 'eslint_d' },
    typescriptreact = { 'eslint_d' },
    dockerfile = { 'hadolint' },
    sql = { 'sqlfluff' },
    mysql = { 'sqlfluff' },
    plsql = { 'sqlfluff' },
    markdown = { 'markdownlint', 'typos' },
    terraform = { 'terraform_validate' },
    tf = { 'terraform_validate' },
    gitcommit = { 'typos' },
    text = { 'typos' },
}

local sql_filetypes = { sql = true, mysql = true, plsql = true }
local sqlfluff_config_files = { '.sqlfluff', 'pep8.ini', 'pyproject.toml', 'setup.cfg', 'tox.ini' }

vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufReadPost', 'FileType', 'InsertLeave' }, {
    group = vim.api.nvim_create_augroup('nvim-lint', { clear = true }),
    callback = function(event)
        if sql_filetypes[vim.bo[event.buf].filetype] then
            if event.event == 'InsertLeave' then
                return
            end

            local config = vim.fs.find(sqlfluff_config_files, {
                path = vim.fs.dirname(vim.api.nvim_buf_get_name(event.buf)),
                upward = true,
            })[1]
            if config then
                lint.try_lint('sqlfluff', { cwd = vim.fs.dirname(config) })
            end
            return
        end

        lint.try_lint()
    end,
})

-- vim.keymap.set('n', '<leader>cl', function()
--     lint.try_lint()
-- end, { desc = '[C]ode [L]int' })
