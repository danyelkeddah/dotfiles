require('tokyonight').setup({
    on_colors = function(colors)
        colors.gitSigns = {
            add = colors.teal,
            change = colors.purple,
            delete = colors.red,
        }
    end,
    on_highlights = function(hl, c)
        local util = require('tokyonight.util')

        hl.GitSignsCurrentLineBlame = { fg = c.fg_gutter }

        hl.StatusLine = { bg = util.darken(c.bg_dark, 0.98, '#000000'), fg = c.fg_dark }
        hl.StatusLineComment = { bg = util.darken(c.bg_dark, 0.85, '#000000'), fg = c.comment }

        hl.LineNrAbove = { fg = c.fg_gutter }
        hl.LineNr = { fg = util.lighten(c.fg_gutter, 0.7) }
        hl.LineNrBelow = { fg = c.fg_gutter }

        hl.MsgArea = { bg = util.darken(c.bg_dark, 0.85, '#000000') }

        hl.SpellBad = { undercurl = true, sp = '#7F3A43' }
    end,
})
