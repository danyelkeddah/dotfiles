return {
    'mbbill/undotree',
    config = function()
        vim.keymap.set('n', '<leader>ud', vim.cmd.UndotreeToggle)
        vim.g.undotree_WindowLayout = 2
    end,
}
