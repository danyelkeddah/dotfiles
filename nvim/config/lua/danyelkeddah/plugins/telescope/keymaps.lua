return {
    {
        '<leader>,',
        function()
            require('telescope.builtin').buffers({ prompt_title = 'Buffers', sort_mru = true, sort_lastused = true })
        end,
        desc = 'Switch Buffer',
    },
    {
        '<leader>/',
        function()
            require('telescope').extensions.live_grep_args.live_grep_args()
        end,
        desc = 'Grep (root dir)',
    },
    {
        '<leader>:',
        '<cmd>Telescope command_history<cr>',
        desc = 'Command History',
    },
    {
        '<leader><space>',
        function()
            require('telescope.builtin').find_files()
        end,
        desc = 'Find files',
    },
    {
        '<leader>fb',
        '<cmd>Telescope buffers<cr>',
        desc = 'Buffers',
    },
    {
        '<leader>fr',
        function()
            require('telescope.builtin').oldfiles({
                prompt_title = 'Project history',
                cwd_only = true,
            })
        end,
        desc = 'Find Recent',
    },
    {
        '<leader>fR',
        function()
            require('telescope.builtin').oldfiles({
                prompt_title = 'Global History',
                cwd_only = false,
            })
        end,
        desc = 'Recent (cwd)',
    },
    -- search
    { '<leader>sb', '<cmd>Telescope current_buffer_fuzzy_find<cr>', desc = 'Buffer' },
    { '<leader>sC', '<cmd>Telescope commands<cr>', desc = 'Commands' },
    { '<leader>sd', '<cmd>Telescope diagnostics bufnr=0<cr>', desc = 'Document diagnostics' },
    { '<leader>sD', '<cmd>Telescope diagnostics<cr>', desc = 'Workspace diagnostics' },
    {
        '<leader>ss',
        function()
            require('telescope.builtin').lsp_document_symbols({
                prompt_title = 'LSP Document Methods',
                symbols = { 'method' },
                symbol_width = 80,
            })
        end,
        desc = 'Goto Symbol',
    },
    {
        '<leader>sS',
        function()
            require('telescope.builtin').lsp_document_symbols()
        end,
        desc = 'Goto Symbol (Workspace)',
    },
}
