require('oil').setup({
    skip_confirm_for_simple_edits = true,
    delete_to_trash = true,
    view_options = {
        show_hidden = true,
        is_always_hidden = function(name, _)
            return name == '..' or name == '.git'
        end,
    },
    win_options = {
        wrap = true,
    },
    keymaps = {
        ['<C-h>'] = false,
        ['<C-l>'] = false,
        ['<C-k>'] = false,
        ['<C-j>'] = false,
    },
})

vim.keymap.set('n', '<Leader>E', function()
    require('oil').toggle_float()
end, { desc = 'Open parent directory (popup)' })

vim.keymap.set('n', '<Leader>e', '<cmd>Oil<cr>', { desc = 'Open parent directory' })
