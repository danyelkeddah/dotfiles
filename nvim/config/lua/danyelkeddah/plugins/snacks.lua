require('snacks').setup({
    bigfile = { enabled = true }, -- disables LSP/treesitter/syntax when opening files > 1.5MB
    quickfile = { enabled = true }, -- renders the file before plugins load, making cold-open feel instant
    notifier = { enabled = true }, -- replaces vim.notify with a floating UI
    input = { enabled = true }, -- replaces vim.ui.input with a floating prompt
    picker = { enabled = true }, -- fuzzy picker for files/grep/buffers/LSP/git
    gitbrowse = { enabled = true }, -- open current line on GitHub/GitLab in a browser
    rename = { enabled = true }, -- rename the current file + fix LSP imports
    words = { enabled = true }, -- jump between LSP references of the word under the cursor
})

_G.dd = function(...)
    Snacks.debug.inspect(...)
end
_G.bt = function()
    Snacks.debug.backtrace()
end
vim.print = _G.dd -- make `:lua =foo` use snacks' pretty inspector

local map = vim.keymap.set

-- stylua: ignore start

-- Utilities
map('n', '<leader>bd', function() Snacks.bufdelete() end, { desc = 'Delete buffer' })
map({ 'n', 'v' }, '<leader>gB', function() Snacks.gitbrowse() end, { desc = 'Git browse (open in browser)' })
map('n', '<leader>n', function() Snacks.notifier.show_history() end, { desc = 'Notification history' })
map('n', '<leader>un', function() Snacks.notifier.hide() end, { desc = 'Dismiss all notifications' })
map('n', '<leader>cR', function() Snacks.rename.rename_file() end, { desc = 'Rename file (with LSP)' })
map({ 'n', 't' }, ']]', function() Snacks.words.jump(vim.v.count1) end, { desc = 'Next reference' })
map({ 'n', 't' }, '[[', function() Snacks.words.jump(-vim.v.count1) end, { desc = 'Prev reference' })

-- Find (files / buffers)
map('n', '<leader><space>', function() Snacks.picker.smart({ layout = { preset = 'vscode' }, filter = { cwd = true } }) end, { desc = 'Smart find files' })
map('n', '<leader>,', function() Snacks.picker.buffers({ layout = { preset = 'vscode', backdrop = true } }) end, { desc = 'Buffers' })
map('n', '<leader>ff', function() Snacks.picker.files() end, { desc = 'Find files' })
map('n', '<leader>fr', function() Snacks.picker.recent() end, { desc = 'Recent files' })
map('n', '<leader>fb', function() Snacks.picker.buffers() end, { desc = 'Buffers' })
map('n', '<leader>fc', function() Snacks.picker.files({ cwd = vim.fn.stdpath('config') }) end, { desc = 'Find config file' })

-- Grep
map('n', '<leader>/', function() Snacks.picker.grep() end, { desc = 'Grep (project)' })

-- Search / discovery
map('n', '<leader>sd', function() Snacks.picker.diagnostics() end, { desc = 'Diagnostics' })
map('n', '<leader>sk', function() Snacks.picker.keymaps() end, { desc = 'Keymaps' })
map('n', '<leader>sh', function() Snacks.picker.help() end, { desc = 'Help pages' })
map('n', '<leader>sR', function() Snacks.picker.resume() end, { desc = 'Resume last picker' })
map('n', '<leader>st', function() Snacks.picker.grep({ search = '\\b(TODO|FIX|FIXME|HACK|NOTE):' }) end, { desc = 'Search TODOs' })

-- Git (note: <leader>gs stays on fugitive's status buffer)
map('n', '<leader>gl', function() Snacks.picker.git_log() end, { desc = 'Git log' })
map('n', '<leader>gb', function() Snacks.picker.git_branches() end, { desc = 'Git branches' })

-- LSP navigation
map('n', 'gd', function() Snacks.picker.lsp_definitions() end, { desc = 'Goto definition' })
map('n', 'gr', function() Snacks.picker.lsp_references() end, { desc = 'References', nowait = true })
map('n', 'gI', function() Snacks.picker.lsp_implementations() end, { desc = 'Goto implementation' })
map('n', 'gy', function() Snacks.picker.lsp_type_definitions() end, { desc = 'Goto type definition' })

-- stylua: ignore end
