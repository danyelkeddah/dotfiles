---@class snacks.Config
local o = {

    ---@class snacks.animate.Config
    animate = {
        enabled = true,
        duration = 20,
        easing = 'linear',
        fps = 60,
    },

    ---@class snacks.bigfile.Config
    bigfile = {
        enabled = true,
        notify = true,
        line_length = 1000,
        size = 1.5 * 1024 * 1024, -- 1.5MB
        setup = function(ctx)
            if vim.fn.exists(':NoMatchParen') ~= 0 then
                vim.cmd([[NoMatchParen]])
            end
            Snacks.util.wo(0, { foldmethod = 'manual', statuscolumn = '', conceallevel = 0 })
            vim.b.minianimate_disable = true
            vim.schedule(function()
                if vim.api.nvim_buf_is_valid(ctx.buf) then
                    vim.bo[ctx.buf].syntax = ctx.ft
                end
            end)
        end,
    },

    ---@class snacks.dashboard.Config
    dashboard = {
        enabled = true,
    },

    ---@class snacks.dim.Config
    dim = {
        enabled = true,
        scope = {
            min_size = 5,
            max_size = 20,
            siblings = true,
        },
        -- animate scopes. Enabled by default for Neovim >= 0.10
        -- Works on older versions but has to trigger redraws during animation.
        ---@type snacks.animate.Config|{enabled?: boolean}
        animate = {
            enabled = vim.fn.has('nvim-0.10') == 1,
            easing = 'outQuad',
            duration = {
                step = 20, -- ms per step
                total = 300, -- maximum duration
            },
        },
        -- what buffers to dim
        filter = function(buf)
            return vim.g.snacks_dim ~= false and vim.b[buf].snacks_dim ~= false and vim.bo[buf].buftype == ''
        end,
    },

    ---@class snacks.explorer.Config
    explorer = {
        enabled = false,
    },

    ---@class snacks.gitbrowse.Config
    gitbrowse = {
        enabled = true,
        notify = true,
    },

    ---@class snacks.image.Config
    image = {
        enabled = true,
    },

    ---@class snacks.indent.Config
    indent = {
        enabled = false,
    },

    ---@class snacks.input.Config
    input = {
        enabled = true,
    },

    ---@class snacks.layout.Config
    layout = {
        enabled = true,
        layout = {
            width = 0.6,
            height = 0.6,
            zindex = 50,
        },
    },

    ---@class snacks.lazygit.Config: snacks.terminal.Opts
    lazygit = {
        enabled = true,
    },

    ---@class snacks.notifier.Config
    notifier = {
        enabled = true,
    },

    ---@class snacks.picker.Config
    picker = {
        enabled = false,
    },

    ---@class snacks.quickfile.Config
    quickfile = {
        enabled = true,
        exclude = { 'latex' },
    },
    ---@class snacks.rename.Config
    rename = {
        enabled = true,
    },

    ---@class snacks.scope.Config
    scope = {
        enabled = true,
    },

    ---@class snacks.scratch.Config
    scratch = {
        enabled = false,
    },

    ---@class snacks.scroll.Config
    scroll = {
        enabled = true,
    },

    ---@class snacks.statuscolumn.Config
    statuscolumn = {
        enabled = true,
        left = { 'mark', 'sign' }, -- priority of signs on the left (high to low)
        right = { 'fold', 'git' }, -- priority of signs on the right (high to low)
        folds = {
            open = false, -- show open fold icons
            git_hl = false, -- use Git Signs hl for fold icons
        },
        git = {
            -- patterns to match Git signs
            patterns = { 'GitSign', 'MiniDiffSign' },
        },
        refresh = 50, -- refresh at most every 50ms
    },

    ---@class snacks.terminal.Config
    terminal = {
        enabled = true,
        win = { style = 'terminal' },
    },

    ---@class snacks.toggle.Config
    toggle = {
        enabled = true,
    },

    ---@class snacks.words.Config
    words = {
        enabled = true,
    },

    ---@class snacks.zen.Config
    zen = {
        enabled = true,
    },
}

return {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    dependencies = {
        'echasnovski/mini.icons',
    },
    ---@class snacks.Config
    opts = o,
    init = function()
        vim.api.nvim_create_autocmd('User', {
            pattern = 'VeryLazy',
            callback = function()
                -- Setup some globals for debugging (lazy-loaded)
                _G.dd = function(...)
                    Snacks.debug.inspect(...)
                end
                _G.bt = function()
                    Snacks.debug.backtrace()
                end
                vim.print = _G.dd -- Override print to use snacks for `:=` command
            end,
        })
    end,
    -- stylua: ignore
    ---@param opts snacks.Config
    config = function(_, opts)
    
        require('snacks').setup(opts)

        vim.keymap.set('n', '<leader>bd', function() Snacks.bufdelete() end, { desc = 'Delete Buffer' })
        vim.keymap.set({ 'n', 'v' }, '<leader>gB', function() Snacks.gitbrowse() end, { desc = 'Git Browse' })
        vim.keymap.set("n", '<leader>gg', function() Snacks.lazygit() end, { desc = 'Lazygit' })
        vim.keymap.set('n', '<leader>n', function() Snacks.notifier.show_history() end, { desc = 'Notification History' })
        vim.keymap.set("n", '<leader>un', function() Snacks.notifier.hide() end, { desc = 'Dismiss All Notifications' })

        if opts.picker.enabled then

        -- Top Pickers & Explorer
        vim.keymap.set('n', '<leader><space>', function() Snacks.picker.smart({layout = {preset = 'vscode'},filter = {cwd = true}}) end, { desc = 'Smart Find Files' })
        vim.keymap.set('n', '<leader>,', function() Snacks.picker.buffers({layout = {preset = 'vscode', backdrop = true}}) end, { desc = 'Buffers' })
        vim.keymap.set('n', '<leader>/', function() Snacks.picker.grep() end, { desc = 'Grep' })
        vim.keymap.set('n', '<leader>:', function() Snacks.picker.command_history() end, { desc = 'Command History' })
        vim.keymap.set('n', '<leader>n', function() Snacks.picker.notifications() end, { desc = 'Notification History' })

        -- find
        vim.keymap.set('n', '<leader>fb', function() Snacks.picker.buffers({layout = {preset = 'vscode'}}) end, { desc = 'Buffers' })
        vim.keymap.set('n', '<leader>fc', function() Snacks.picker.files({ cwd = vim.fn.stdpath("config"), layout = {preset = 'vscode'} }) end, { desc = 'Find Config File' })
        vim.keymap.set('n', '<leader>ff', function() Snacks.picker.files({filter = {cwd = true}}) end, { desc = 'Find Files' })
        vim.keymap.set('n', '<leader>fg', function() Snacks.picker.git_files({filter = {cwd = true}}) end, { desc = 'Find Git Files' })
        vim.keymap.set('n', '<leader>fp', function() Snacks.picker.projects() end, { desc = 'Projects' })
        vim.keymap.set('n', '<leader>fr', function() Snacks.picker.recent({layout = {preset = 'vscode' },filter = { cwd = true }}) end, { desc = 'Recent' })

        -- git
        vim.keymap.set('n', '<leader>gb', function() Snacks.picker.git_branches() end, { desc = 'Git Branches' })
        vim.keymap.set('n', '<leader>gl', function() Snacks.picker.git_log() end, { desc = 'Git Log' })
        vim.keymap.set('n', '<leader>gL', function() Snacks.picker.git_log_line() end, { desc = 'Git Log Line' })
        vim.keymap.set('n', '<leader>gs', function() Snacks.picker.git_status() end, { desc = 'Git Status' })
        vim.keymap.set('n', '<leader>gS', function() Snacks.picker.git_stash() end, { desc = 'Git Stash' })
        vim.keymap.set('n', '<leader>gd', function() Snacks.picker.git_diff() end, { desc = 'Git Diff (hunks)' })
        vim.keymap.set('n', '<leader>gf', function() Snacks.picker.git_log_file() end, { desc = 'Git Log File' })

          -- Grep
        vim.keymap.set('n', '<leader>sb', function() Snacks.picker.lines() end, { desc = 'Buffer Lines' })
        vim.keymap.set('n', '<leader>sB', function() Snacks.picker.grep_buffers() end, { desc = 'Grep Open Buffers' })
        vim.keymap.set('n', '<leader>sg', function() Snacks.picker.grep() end, { desc = 'Grep' })
        vim.keymap.set({'n', 'x'}, '<leader>sw', function() Snacks.picker.registers() end, { desc = 'Registers' })

        -- search
        vim.keymap.set('n', '<leader>s"', function() Snacks.picker.registers() end, { desc = 'Registers' })
        vim.keymap.set('n', '<leader>s/', function() Snacks.picker.search_history() end, { desc = 'Search History' })
        vim.keymap.set('n', '<leader>sa', function() Snacks.picker.autocmds() end, { desc = 'Autocmds' })
        vim.keymap.set('n', '<leader>sb', function() Snacks.picker.lines() end, { desc = 'Buffer Lines' })
        vim.keymap.set('n', '<leader>sc', function() Snacks.picker.command_history() end, { desc = 'Command History' })
        vim.keymap.set('n', '<leader>sC', function() Snacks.picker.commands() end, { desc = 'Commands' })
        vim.keymap.set('n', '<leader>sd', function() Snacks.picker.diagnostics() end, { desc = 'Diagnostics' })
        vim.keymap.set('n', '<leader>sD', function() Snacks.picker.diagnostics_buffer() end, { desc = 'Buffer Diagnostics' })
        vim.keymap.set('n', '<leader>sh', function() Snacks.picker.help() end, { desc = 'Help Pages' })
        vim.keymap.set('n', '<leader>sH', function() Snacks.picker.highlights() end, { desc = 'Highlights' })
        vim.keymap.set('n', '<leader>si', function() Snacks.picker.icons() end, { desc = 'Icons' })
        vim.keymap.set('n', '<leader>sj', function() Snacks.picker.jumps() end, { desc = 'Jumps' })
        vim.keymap.set('n', '<leader>sk', function() Snacks.picker.keymaps() end, { desc = 'Keymaps' })
        vim.keymap.set('n', '<leader>sl', function() Snacks.picker.loclist() end, { desc = 'Location List' })
        vim.keymap.set('n', '<leader>sm', function() Snacks.picker.marks() end, { desc = 'Marks' })
        vim.keymap.set('n', '<leader>sM', function() Snacks.picker.man() end, { desc = 'Man Pages' })
        vim.keymap.set('n', '<leader>sp', function() Snacks.picker.lazy() end, { desc = 'Search for Plugin Spec' })
        vim.keymap.set('n', '<leader>sq', function() Snacks.picker.qflist() end, { desc = 'Quickfix List' })
        vim.keymap.set('n', '<leader>sR', function() Snacks.picker.resume() end, { desc = 'Resume' })
        vim.keymap.set('n', '<leader>su', function() Snacks.picker.undo() end, { desc = 'Undo History' })
        vim.keymap.set('n', '<leader>uC', function() Snacks.picker.colorschemes() end, { desc = 'Colorschemes' })

        -- LSP
        vim.keymap.set('n', 'gd', function() Snacks.picker.lsp_definitions() end, { desc = 'Goto Definition' })
        vim.keymap.set('n', 'gD', function() Snacks.picker.lsp_declarations() end, { desc = 'Goto Declaration' })
        vim.keymap.set('n', 'gr', function() Snacks.picker.lsp_references() end, { desc = 'References', nowait = true })
        vim.keymap.set('n', 'gI', function() Snacks.picker.lsp_implementations() end, { desc = 'Goto Implementation' })
        vim.keymap.set('n', 'gy', function() Snacks.picker.lsp_type_definitions() end, { desc = 'Goto T[y]pe Definition' })
        vim.keymap.set('n', '<leader>ss', function() Snacks.picker.lsp_symbols() end, { desc = 'LSP Symbols' })
        vim.keymap.set('n', '<leader>sS', function() Snacks.picker.lsp_workspace_symbols() end, { desc = 'LSP Workspace Symbols' })
        end

        vim.keymap.set('n', '<leader>cR', function() Snacks.rename.rename_file() end, { desc = 'Rename File' })

        vim.keymap.set('n', '<leader>.', function() Snacks.scratch() end, { desc = 'Toggle Scratch Buffer' })
        vim.keymap.set('n', '<leader>S', function() Snacks.scratch.select() end, { desc = 'Select Scratch Buffer' })

        vim.keymap.set("n", '<c-/>', function() Snacks.terminal() end, { desc = 'Toggle Terminal' })
        vim.keymap.set("n", '<c-_>', function() Snacks.terminal() end, { desc = 'which_key_ignore' })


        -- Snacks.toggle.option('spell', { name = 'Spelling' }):map('<leader>us')
        -- Snacks.toggle.option('wrap', { name = 'Wrap' }):map('<leader>uw')
        -- Snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map('<leader>uL')
        -- Snacks.toggle.diagnostics():map('<leader>ud')
        -- Snacks.toggle.line_number():map('<leader>ul')
        -- Snacks.toggle.option('conceallevel', { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map('<leader>uc')
        -- Snacks.toggle.treesitter():map('<leader>uT')
        -- Snacks.toggle.option('background', { off = 'light', on = 'dark', name = 'Dark Background' }):map('<leader>ub')
        -- Snacks.toggle.inlay_hints():map('<leader>uh')
        -- Snacks.toggle.indent():map('<leader>ug')
        -- Snacks.toggle.dim():map('<leader>uD')

        vim.keymap.set({ "n", "t" }, ']]',function() Snacks.words.jump(vim.v.count1) end, { desc = 'Next Reference' })
        vim.keymap.set({ "n", "t" }, '[[',function() Snacks.words.jump(-vim.v.count1) end, { desc = 'Prev Reference' })

        vim.keymap.set('n', '<leader>z', function() Snacks.zen() end, { desc = 'Toggle Zen Mode' })
        vim.keymap.set('n', '<leader>Z', function() Snacks.zen.zoom() end, { desc = 'Toggle Zoom' })
    end,
}
