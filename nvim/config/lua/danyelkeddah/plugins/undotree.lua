vim.keymap.set('n', '<leader>uu', function()
    vim.cmd.packadd('nvim.undotree')
    vim.cmd.Undotree()
end, { desc = 'Toggle undotree' })
