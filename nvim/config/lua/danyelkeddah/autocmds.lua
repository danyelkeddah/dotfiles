local function augroup(name)
    return vim.api.nvim_create_augroup(name, {
        clear = true,
    })
end

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
    group = augroup('checktime'),
    callback = function()
        if vim.o.buftype ~= 'nofile' then
            vim.cmd('checktime')
        end
    end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
    group = augroup('HighlightYank'),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ 'VimResized' }, {
    group = augroup('ResizeSplits'),
    callback = function()
        local current_tab = vim.fn.tabpagenr()
        vim.cmd('tabdo wincmd =')
        vim.cmd('tabnext ' .. current_tab)
    end,
})

-- go to last locaction when opening a buffer
vim.api.nvim_create_autocmd('BufReadPost', {
    group = augroup('LastLocation'),
    callback = function(event)
        local exclude = { 'gitcommit' }
        local buf = event.buf
        if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
            return
        end
        vim.b[buf].lazyvim_last_loc = true
        local mark = vim.api.nvim_buf_get_mark(buf, '"')
        local lcount = vim.api.nvim_buf_line_count(buf)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd('FileType', {
    group = augroup('CloseWithQ'),
    pattern = {
        'PlenaryTestPopup',
        'help',
        'lspinfo',
        'man',
        'notify',
        'qf',
        'query',
        'spectre_panel',
        'startuptime',
        'tsplayground',
        'neotest-output',
        'checkhealth',
        'neotest-summary',
        'neotest-output-panel',
        'oil',
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set('n', 'q', '<cmd>close<cr>', {
            buffer = event.buf,
            silent = true,
        })
    end,
})

-- Fix conceallevel for json files
-- vim.api.nvim_create_autocmd({ 'FileType' }, {
--   group = augroup('JsonConceal'),
--   pattern = { 'json', 'jsonc', 'json5' },
--   callback = function()
--     vim.opt_local.conceallevel = 0
--   end,
-- })

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd('FileType', {
    group = augroup('WrapSpell'),
    pattern = { 'gitcommit', 'markdown' },
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.spell = true
    end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
    group = augroup('AutoCreateDir'),
    callback = function(event)
        if event.match:match('^%w%w+://') then
            return
        end
        local file = vim.loop.fs_realpath(event.match) or event.match
        vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
    end,
})

-- disable minipairs with markdown to avoid ``` duplications
vim.api.nvim_create_autocmd('Filetype', {
    group = augroup('DisableMiniPairs'),
    pattern = { 'markdown' },
    callback = function(event)
        vim.b.minipairs_disable = true
    end,
})

-- vim.api.nvim_create_autocmd('FileType', {
--   pattern = { 'hcl', 'terraform' },
--   desc = 'terraform/hcl commentstring configuration',
--   command = 'setlocal commentstring=#\\ %s',
-- })

-- disable markdown conceling while editting
vim.api.nvim_create_autocmd({ 'InsertEnter', 'InsertLeave' }, {
    group = augroup('EnableAndDisableConcealLevelWhenEditingMarkdown'),
    pattern = { '*.md' },
    callback = function(event)
        if event.event == 'InsertEnter' then
            vim.opt_local.conceallevel = 0
        elseif event.event == 'InsertLeave' then
            vim.opt_local.conceallevel = 2
        end
    end,
})

-- vim.api.nvim_create_autocmd('CmdlineLeave', {
--     group = augroup('CmdLineLeave'),
--     callback = function()
--         vim.fn.timer_start(5000, function()
--             print(' ')
--         end)
--     end,
-- })
-- vim.api.nvim_create_autocmd('FileType', {
--     pattern = { 'json' },
--     callback = function()
--         vim.api.nvim_set_option_value('formatprg', 'jq', { scope = 'local' })
--     end,
-- })

local disable_semantic_tokens = {
    lua = true,
}

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        local bufnr = args.buf
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id), 'must have a valid client')
        vim.opt_local.omnifunc = 'v:lua.vim.lsp.omnifunc'

        -- vim.keymap.set('n', '<leader>cl', '<cmd>LspInfo<cr>', { desc = 'Lsp Info' })
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'Goto Definition' })
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, { nowait = true, desc = 'References' })
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = 'Goto Declaration' })
        vim.keymap.set('n', 'gI', vim.lsp.buf.implementation, { desc = 'Goto Implementation' })
        vim.keymap.set('n', 'gT', vim.lsp.buf.type_definition, { desc = 'Goto Type Definition' })
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'Hover' })
        vim.keymap.set('n', 'gK', vim.lsp.buf.signature_help, { desc = 'Signature Help' })
        vim.keymap.set('i', '<c-k>', vim.lsp.buf.signature_help, { desc = 'Signature Help' })
        vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, { desc = 'Code Action' })
        vim.keymap.set({ 'n', 'v' }, '<space>cc', vim.lsp.codelens.run, { desc = 'Run Codelens' })
        vim.keymap.set('n', '<space>cC', vim.lsp.codelens.refresh, { desc = 'Refresh & Display Codelens' })
        vim.keymap.set('n', '<space>cr', vim.lsp.buf.rename, { desc = 'Rename' })
        vim.keymap.set('n', '<space>cA', function()
            vim.lsp.buf.code_action({
                apply = true,
                context = {
                    only = {
                        'source',
                    },
                    diagnostics = {},
                },
            })
        end, { desc = 'Source Action' })

        local filetype = vim.bo[bufnr].filetype
        if disable_semantic_tokens[filetype] then
            client.server_capabilities.semanticTokensProvider = nil
        end
        -- if client:supports_method('textDocument/completion') then
        --     vim.lsp.completion.enable(true, client.id, args.buf, {
        --         autotrigger = true,
        --         convert = function(item)
        --             print(item.king)
        --             return {}
        --         end,
        --     })
        -- end
    end,
})

vim.api.nvim_create_autocmd('BufReadPost', {
    group = augroup('MakeRouteTreeReadOnly'),
    pattern = { '*/routeTree.gen.ts', '*/route-tree.gen.ts' },
    callback = function()
        vim.opt_local.readonly = true
        -- vim.opt_local.modifiable = false
    end,
})
