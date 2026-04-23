local signs = {
    add = { text = '▎' },
    change = { text = '▎' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
    untracked = { text = '▎' },
}

require('gitsigns').setup({
    signs = signs,
    signs_staged = signs,
    on_attach = function(buffer)
        local gs = require('gitsigns')
        local function map(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = buffer, desc = desc })
        end

        map('n', ']h', function() gs.nav_hunk('next') end, 'Next hunk')
        map('n', '[h', function() gs.nav_hunk('prev') end, 'Prev hunk')
        map('n', ']H', function() gs.nav_hunk('last') end, 'Last hunk')
        map('n', '[H', function() gs.nav_hunk('first') end, 'First hunk')
        map({ 'n', 'v' }, '<leader>ghs', ':Gitsigns stage_hunk<cr>', 'Stage hunk')
        map({ 'n', 'v' }, '<leader>ghr', ':Gitsigns reset_hunk<cr>', 'Reset hunk')
        map('n', '<leader>ghS', gs.stage_buffer, 'Stage buffer')
        map('n', '<leader>ghu', gs.undo_stage_hunk, 'Undo stage hunk')
        map('n', '<leader>ghR', gs.reset_buffer, 'Reset buffer')
        map('n', '<leader>ghp', gs.preview_hunk_inline, 'Preview hunk inline')
        map('n', '<leader>ghb', function() gs.blame_line({ full = true }) end, 'Blame line')
        map('n', '<leader>ghd', function() gs.diffthis('~') end, 'Diff against HEAD~')
    end,
})
