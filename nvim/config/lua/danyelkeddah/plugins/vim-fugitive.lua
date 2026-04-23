vim.keymap.set('n', '<leader>gs', '<cmd>Git<cr>', { desc = 'Git status' })
vim.keymap.set('v', '<leader>gb', "<cmd>'<,'>GBrowse<cr>", { desc = 'Git browse' })
vim.keymap.set('n', '<leader>gP', '<cmd>Git push<cr>', { desc = 'Git push' })
vim.keymap.set('n', '<leader>gp', '<cmd>Git pull<cr>', { desc = 'Git pull' })

vim.api.nvim_create_autocmd('Filetype', {
    pattern = 'fugitive',
    group = vim.api.nvim_create_augroup('FugitiveOpen', { clear = true }),
    callback = function()
        vim.cmd.normal('gg]]')
    end,
})
