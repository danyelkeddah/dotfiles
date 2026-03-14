return {
    'stevearc/oil.nvim',
    enabled = true,
    keys = {
        {
            '<Leader>E',
            function()
                require('oil').toggle_float()
            end,
            desc = 'Open parent directory (popup)',
        },
        {
            '<Leader>e',
            '<CMD>Oil<CR>',
            desc = 'Open parent directory',
        },
    },
    opts = {
        skip_confirm_for_simple_edits = true,
        -- columns = { 'icon' },
        view_options = {
            show_hidden = true,
            natural_order = true,
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
        delete_to_trash = true,
    },
}
