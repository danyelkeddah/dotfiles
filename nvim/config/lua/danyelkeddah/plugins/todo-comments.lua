return {
    'folke/todo-comments.nvim',
    enabled = true,
    cmd = { 'TodoTrouble', 'TodoTelescope' },
    event = { 'BufReadPost', 'BufNewFile' },
    opts = function()
        local icons = require('danyelkeddah.icons')
        return {
            keywords = {
                FIX = { icon = icons.ui.Bug .. ' ', color = 'error', alt = { 'FIXME', 'BUG', 'FIXIT', 'ISSUE' } },
                TODO = { icon = icons.ui.Check .. ' ', color = 'info', alt = { 'TODO' } },
                HACK = { icon = icons.ui.Fire .. ' ', color = 'warning', alt = { 'HACK' } },
                WARN = { icon = icons.diagnostics.Warning .. ' ', color = 'warning', alt = { 'WARNING', 'XXX' } },
                NOTE = { icon = icons.ui.Note .. ' ', color = 'hint', alt = { 'INFO', 'MARK' } },
            },
        }
    end,
    -- stylua: ignore
    keys = {
        { ']t', function() require('todo-comments').jump_next() end, desc = 'Next todo comment' },
        { '[t', function() require('todo-comments').jump_prev() end, desc = 'Previous todo comment' },
        { '<leader>xt', '<cmd>Trouble todo toggle<cr>', desc = 'Todo (Trouble)' },
        { '<leader>xT', '<cmd>Trouble todo toggle filter = {tag = {TODO,FIX}}<cr>', desc = 'Todo/Fix (Trouble)' },
        { '<leader>st', function() Snacks.picker.todo_comments() end, desc = 'Todo' },
        { '<leader>sT', function() Snacks.picker.todo_comments({keywords = { "TODO", "FIX", "FIXME" }}) end, desc = 'Todo/Fix' },
    },
}
