return {
    'saghen/blink.cmp',
    enabled = true,
    version = '*',
    dependencies = {
        {
            'Kaiser-Yang/blink-cmp-git',
            dependencies = { 'nvim-lua/plenary.nvim' },
        },
        {
            'L3MON4D3/LuaSnip',
            build = 'make install_jsregexp',
        },
    },
    opts = {
        keymap = {
            preset = 'enter',
            ['<Tab>'] = {
                function(cmp)
                    if cmp.snippet_active() then
                        return cmp.accept()
                    else
                        return cmp.select_and_accept()
                    end
                end,
                'snippet_forward',
                'fallback',
            },
        },
        appearance = {
            use_nvim_cmp_as_default = false,
            nerd_font_variant = 'mono',
        },
        sources = {
            default = { 'conventional_commits', 'git', 'lsp', 'path', 'snippets', 'buffer' },
            providers = {
                git = {
                    module = 'blink-cmp-git',
                    name = 'Git',
                    enabled = function()
                        return vim.bo.filetype == 'gitcommit'
                    end,
                    opts = {
                        -- options for the blink-cmp-git
                    },
                },
                dadbod = { name = 'Dadbod', module = 'vim_dadbod_completion.blink' },
                conventional_commits = {
                    name = 'Conventional Commits',
                    module = 'blink-cmp-conventional-commits',
                    enabled = function()
                        return vim.bo.filetype == 'gitcommit'
                    end,
                    ---@module 'blink-cmp-conventional-commits'
                    ---@type blink-cmp-conventional-commits.Options
                    opts = {}, -- none so far
                },
            },
        },
        signature = { enabled = true },
        completion = {
            -- list = {
            --     selection = {
            --         preselect = false,
            --     },
            -- },
            menu = {
                draw = {
                    components = {
                        kind_icon = {
                            text = function(ctx)
                                local kind_icon, _, _ = require('mini.icons').get('lsp', ctx.kind)
                                return kind_icon
                            end,
                            -- (optional) use highlights from mini.icons
                            highlight = function(ctx)
                                local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
                                return hl
                            end,
                        },
                        kind = {
                            -- (optional) use highlights from mini.icons
                            highlight = function(ctx)
                                local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
                                return hl
                            end,
                        },
                    },
                },
            },
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 200,
            },
        },
    },
}
