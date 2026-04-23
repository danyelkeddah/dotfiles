local augroup = function(name)
    return vim.api.nvim_create_augroup('danyelkeddah_' .. name, { clear = true })
end

-- Reload buffers when their files change on disk (after focus gain or terminal exit).
vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
    group = augroup('checktime'),
    callback = function()
        if vim.o.buftype ~= 'nofile' then
            vim.cmd('checktime')
        end
    end,
})

-- Briefly highlight the region just yanked so you can see what you copied.
vim.api.nvim_create_autocmd('TextYankPost', {
    group = augroup('HighlightYank'),
    callback = function()
        vim.hl.on_yank()
    end,
})

-- Re-balance window splits across all tabs when the terminal is resized.
vim.api.nvim_create_autocmd('VimResized', {
    group = augroup('ResizeSplits'),
    callback = function()
        local current_tab = vim.fn.tabpagenr()
        vim.cmd('tabdo wincmd =')
        vim.cmd('tabnext ' .. current_tab)
    end,
})

-- Jump to the last known cursor position when opening a file (skip commit messages).
vim.api.nvim_create_autocmd('BufReadPost', {
    group = augroup('LastLocation'),
    callback = function(event)
        local exclude = { 'gitcommit' }
        local buf = event.buf
        if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].last_loc_restored then
            return
        end
        vim.b[buf].last_loc_restored = true
        local mark = vim.api.nvim_buf_get_mark(buf, '"')
        local lcount = vim.api.nvim_buf_line_count(buf)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

-- Map `q` to close utility/scratch buffers (help, quickfix, oil, etc.) and unlist them.
vim.api.nvim_create_autocmd('FileType', {
    group = augroup('CloseWithQ'),
    pattern = {
        'checkhealth',
        'fugitive',
        'grug-far',
        'help',
        'lspinfo',
        'man',
        'oil',
        'qf',
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set('n', 'q', '<cmd>close<cr>', {
            buffer = event.buf,
            silent = true,
        })
    end,
})

-- Enable soft-wrap and spell-check for prose filetypes (commit messages, markdown).
vim.api.nvim_create_autocmd('FileType', {
    group = augroup('WrapSpell'),
    pattern = { 'gitcommit', 'markdown' },
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.spell = true
    end,
})

-- Auto-create missing parent directories when saving a file to a non-existent path.
vim.api.nvim_create_autocmd('BufWritePre', {
    group = augroup('AutoCreateDir'),
    callback = function(event)
        if event.match:match('^%w%w+://') then
            return
        end
        local file = vim.uv.fs_realpath(event.match) or event.match
        vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
    end,
})

-- Disable mini.pairs auto-pairing in markdown (noisy for prose with unbalanced quotes).
vim.api.nvim_create_autocmd('FileType', {
    group = augroup('DisableMiniPairs'),
    pattern = 'markdown',
    callback = function(event)
        vim.b[event.buf].minipairs_disable = true
    end,
})

-- Show raw markdown syntax while editing (conceallevel=0 in insert, 2 in normal).
vim.api.nvim_create_autocmd({ 'InsertEnter', 'InsertLeave' }, {
    group = augroup('MarkdownConceal'),
    callback = function(event)
        if vim.bo[event.buf].filetype ~= 'markdown' then
            return
        end
        vim.opt_local.conceallevel = event.event == 'InsertEnter' and 0 or 2
    end,
})

-- Mark TanStack Router's generated route tree as read-only (it's auto-generated, don't hand-edit).
vim.api.nvim_create_autocmd('BufReadPost', {
    group = augroup('MakeRouteTreeReadOnly'),
    pattern = { '*/routeTree.gen.ts', '*/route-tree.gen.ts' },
    callback = function()
        vim.opt_local.readonly = true
    end,
})

-- Keep the terminal window title in sync with the current working directory.
vim.api.nvim_create_autocmd('DirChanged', {
    group = augroup('UpdateTitle'),
    callback = function()
        vim.opt.titlestring = 'vim (' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':t') .. ')'
    end,
})
