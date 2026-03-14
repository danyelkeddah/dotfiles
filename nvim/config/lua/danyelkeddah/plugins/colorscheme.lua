return {
    {
        'danyelkeddah/lightlite.nvim',
        enabled = false,
        name = 'lightlite',
        priority = 1000,
        dependencies = {
            { 'tjdevries/colorbuddy.nvim', tag = 'v1.0.0' },
        },
        config = function()
            require('lightlite').setup()
            vim.cmd.colorscheme('lightlite')
        end,
    },
    {
        'tiagovla/tokyodark.nvim',
        opts = {},
        enabled = false,
        config = function(_, opts)
            vim.cmd.colorscheme('tokyodark')
        end,
    },
    {
        'danyelkeddah/carbon.nvim',
        priority = 1000,
        lazy = false,
        enabled = false,
        config = function()
            -- vim.cmd.colorscheme('carbon')
        end,
    },
    {
        'catppuccin/nvim',
        enabled = true,
        name = 'catppuccin',
        priority = 1000,
        config = function()
            require('catppuccin').setup({
                flavour = 'mocha', -- latte, frappe, macchiato, mocha
                integrations = {
                    cmp = true,
                    telescope = {
                        enabled = true,
                        -- style = 'nvchad',
                    },
                    blink_cmp = true,
                    gitsigns = true,
                    lsp_trouble = true,
                    nvimtree = true,
                    dadbod_ui = true,
                    which_key = true,
                    treesitter = true,
                    ufo = true,
                    notify = true,
                    nvim_surround = true,
                    treesitter_context = true,
                    mini = true,
                    diffview = true,
                    fidget = true,
                    harpoon = true,
                    markdown = true,
                    mason = true,
                    noice = true,
                    notifier = true,
                    native_lsp = {
                        enabled = false,
                        virtual_text = {
                            errors = { 'italic' },
                            hints = { 'italic' },
                            warnings = { 'italic' },
                            information = { 'italic' },
                            ok = { 'italic' },
                        },
                        underlines = {
                            errors = { 'underline' },
                            hints = { 'underline' },
                            warnings = { 'underline' },
                            information = { 'underline' },
                            ok = { 'underline' },
                        },
                        inlay_hints = {
                            background = true,
                        },
                    },
                    -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
                },
            })
            vim.cmd.colorscheme('catppuccin')
        end,
    },
    {
        'danyelkeddah/github.nvim',
        priority = 1000,
        lazy = false,
        enabled = true,
        config = function()
            -- vim.cmd.colorscheme('github-dark')
        end,
    },
    {
        'rrethy/base16-nvim',
        priority = 1000,
        lazy = false,
        enabled = false,
        config = function()
            -- vim.cmd.colorscheme('base16-tokyo-night-dark')
            -- vim.cmd.colorscheme('base16-tokyo-night-terminal-dark')
            -- vim.cmd.colorscheme('base16-tokyodark')
        end,
    },
    {
        'folke/tokyonight.nvim',
        enabled = false,
        lazy = false,
        priority = 1000,
        opts = { -- test
            on_colors = function(colors)
                colors.gitSigns = {
                    add = colors.teal,
                    change = colors.purple,
                    delete = colors.red,
                }
            end,
            on_highlights = function(hl, c)
                local util = require('tokyonight.util')
                local prompt = '#2d3149'

                hl.BufferlineInactive = {
                    bg = c.bg_dark,
                }
                hl.BufferlineActiveSeparator = {
                    bg = c.bg,
                    fg = util.darken(c.bg_dark, 0.85, '#000000'),
                }
                hl.BufferlineInactiveSeparator = {
                    bg = c.bg_dark,
                    fg = util.darken(c.bg_dark, 0.85, '#000000'),
                }

                hl.NeoTreeFileNameOpened = {
                    fg = c.orange,
                }

                hl.GitSignsCurrentLineBlame = {
                    fg = c.fg_gutter,
                }

                -- Tabs
                hl.TabActive = {
                    bg = c.bg,
                }
                hl.TabActiveSeparator = {
                    bg = c.bg,
                    fg = util.darken(c.bg_dark, 0.85, '#000000'),
                }
                hl.TabInactive = {
                    bg = c.bg_dark,
                }
                hl.TabInactiveSeparator = {
                    bg = c.bg_dark,
                    fg = util.darken(c.bg_dark, 0.85, '#000000'),
                }

                hl.SidebarTabActive = {
                    bg = c.bg_dark,
                }
                hl.SidebarTabActiveSeparator = {
                    bg = c.bg_dark,
                    fg = util.darken(c.bg_dark, 0.85, '#000000'),
                }
                hl.SidebarTabInactive = {
                    bg = util.darken(c.bg_dark, 0.75, '#000000'),
                    fg = c.comment,
                }
                hl.SidebarTabInactiveSeparator = {
                    bg = util.darken(c.bg_dark, 0.75, '#000000'),
                    fg = util.darken(c.bg_dark, 0.85, '#000000'),
                }

                hl.StatusLine = {
                    bg = util.darken(c.bg_dark, 0.98, '#000000'),
                    fg = c.fg_dark,
                }
                hl.StatusLineComment = {
                    bg = util.darken(c.bg_dark, 0.85, '#000000'),
                    fg = c.comment,
                }

                hl.LineNrAbove = {
                    fg = c.fg_gutter,
                }
                hl.LineNr = {
                    fg = util.lighten(c.fg_gutter, 0.7),
                }
                hl.LineNrBelow = {
                    fg = c.fg_gutter,
                }

                hl.MsgArea = {
                    bg = util.darken(c.bg_dark, 0.85, '#000000'),
                }

                -- Spelling
                hl.SpellBad = {
                    undercurl = true,
                    sp = '#7F3A43',
                }

                -- Telescope
                hl.TelescopeNormal = {
                    bg = c.bg_dark,
                    fg = c.fg_dark,
                }
                hl.TelescopeBorder = {
                    bg = c.bg_dark,
                    fg = c.bg_dark,
                }
                hl.TelescopePromptNormal = {
                    bg = prompt,
                }
                hl.TelescopePromptBorder = {
                    bg = prompt,
                    fg = prompt,
                }
                hl.TelescopePromptTitle = {
                    bg = c.bg,
                    fg = c.fg_dark,
                }
                hl.TelescopePreviewTitle = {
                    bg = c.bg_dark,
                    fg = c.bg_dark,
                }
                hl.TelescopeResultsTitle = {
                    bg = c.bg_dark,
                    fg = c.bg_dark,
                }

                -- Indent
                hl.IblIndent = {
                    fg = util.darken(c.bg_highlight, 0.30),
                }
                hl.IblScope = {
                    fg = util.darken(c.bg_highlight, 0.80),
                }

                -- Floaterm
                hl.Floaterm = {
                    bg = prompt,
                }
                hl.FloatermBorder = {
                    bg = prompt,
                    fg = prompt,
                }

                -- Copilot
                hl.CopilotSuggestion = {
                    fg = c.comment,
                }

                -- NvimTree
                hl.NvimTreeIndentMarker = {
                    fg = c.bg_highlight,
                }
                hl.NvimTreeOpenedFile = {
                    fg = c.fg,
                    bold = true,
                }
                hl.NvimTreeNormal = {
                    bg = util.darken(c.bg_dark, 0.85, '#000000'),
                }
                hl.NvimTreeNormalNC = {
                    bg = util.darken(c.bg_dark, 0.85, '#000000'),
                }
                hl.NvimTreeWinSeparator = {
                    fg = util.darken(c.bg_dark, 0.85, '#000000'),
                    bg = util.darken(c.bg_dark, 0.85, '#000000'),
                }
            end,
        },
        config = function(plugin, opts)
            require('tokyonight').setup(opts)

            vim.cmd('colorscheme tokyonight')
        end,
    },
    {
        'sainnhe/gruvbox-material',
        enabled = true,
        priority = 1000,
        config = function()
            vim.g.gruvbox_material_transparent_background = 0
            vim.g.gruvbox_material_foreground = 'mix'
            vim.g.gruvbox_material_background = 'hard'
            vim.g.gruvbox_material_ui_contrast = 'high'
            vim.g.gruvbox_material_float_style = 'bright'
            vim.g.gruvbox_material_statusline_style = 'material'
            vim.g.gruvbox_material_cursor = 'auto'

            vim.g.gruvbox_material_colors_override = { bg0 = '#16181A' } -- #0e1010
            vim.g.gruvbox_material_better_performance = 1

            -- vim.cmd.colorscheme('gruvbox-material')
        end,
    },
}
