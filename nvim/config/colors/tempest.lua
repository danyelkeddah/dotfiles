-- Tempest color scheme for Neovim
-- Converted from PhpStorm Tempest theme

local M = {}

M.setup = function()
    vim.cmd('hi clear')
    if vim.fn.exists('syntax_on') then
        vim.cmd('syntax reset')
    end
    vim.o.background = 'light'
    vim.g.colors_name = 'tempest'

    local colors = {
        fg = '#222222',
        bg = '#FFFFFF',
        caret_row = '#F7F7F7',
        gutter_bg = '#FFFFFF',
        line_numbers = '#555555',
        selection_bg = '#DDDDDD',
        visual_indent = '#F0F0F0',
        right_margin = '#F0F0F0',

        -- Syntax colors
        comment = '#454545',
        comment_bg = '#FFFBF2',
        doc_comment = '#777777',
        keyword = '#4F95D1',
        string = '#222222',
        number = '#222222',
        operator = '#555555',

        class_name = '#D14F57',
        function_name = '#4CB966',
        function_call = '#33A652',
        constant = '#4CB966',
        attribute = '#4CB966',
        static_field = '#4CB966',
        instance_field = '#4CB966',

        error = '#E84135',
        warning = '#D14F57',
        info = '#FCBC05',
        hint = '#4CB966',

        -- Special
        search_bg = '#FCBC05',
        identifier_highlight = '#4CB966',
        parameter_hint_fg = '#454545',
        parameter_hint_bg = '#FFF9EB',

        -- Console colors
        console_bg = '#FEFEFE',
        console_black = '#333333',
        console_red = '#E84135',
        console_green = '#4CB966',
        console_yellow = '#FCBC05',
        console_blue = '#4F95D1',
        console_user_input = '#4CB966',

        -- JSON
        json_property = '#4F95D1',
        json_punctuation = '#4CB966',

        -- Markdown
        markdown_code = '#424242',

        -- Coverage
        coverage_full = '#C8FFB7',
        coverage_partial = '#FFEDB0',
        coverage_none = '#FFCDB0',

        -- Diff
        diff_add = '#E6F3FF',
        diff_delete = '#FFE6FC',
    }

    local hl = function(group, opts)
        vim.api.nvim_set_hl(0, group, opts)
    end

    -- Editor UI
    hl('Normal', { fg = colors.fg, bg = colors.bg })
    hl('NormalFloat', { fg = colors.fg, bg = colors.bg })
    hl('CursorLine', { bg = colors.caret_row })
    hl('CursorLineNr', { fg = colors.line_numbers })
    hl('LineNr', { fg = colors.line_numbers, bg = colors.gutter_bg })
    hl('SignColumn', { bg = colors.gutter_bg })
    hl('Visual', { bg = colors.selection_bg })
    hl('VisualNOS', { bg = colors.selection_bg })
    hl('Search', { bg = colors.search_bg })
    hl('IncSearch', { bg = colors.search_bg, bold = true })
    hl('ColorColumn', { bg = colors.right_margin })
    hl('Folded', { fg = colors.doc_comment, underline = true })
    hl('FoldColumn', { fg = colors.line_numbers, bg = colors.gutter_bg })
    hl('VertSplit', { fg = colors.visual_indent })
    hl('Pmenu', { fg = colors.fg, bg = colors.caret_row })
    hl('PmenuSel', { bg = colors.selection_bg })
    hl('PmenuSbar', { bg = colors.visual_indent })
    hl('PmenuThumb', { bg = colors.line_numbers })
    hl('StatusLine', { fg = colors.fg, bg = colors.caret_row })
    hl('StatusLineNC', { fg = colors.line_numbers, bg = colors.caret_row })
    hl('TabLine', { fg = colors.line_numbers, bg = colors.caret_row })
    hl('TabLineFill', { bg = colors.caret_row })
    hl('TabLineSel', { fg = colors.fg, bg = colors.bg, bold = true })

    -- Syntax highlighting
    hl('Comment', { fg = colors.comment, bg = colors.comment_bg, italic = true })
    hl('Constant', { fg = colors.constant, bold = true })
    hl('String', { fg = colors.string })
    hl('Character', { fg = colors.string })
    hl('Number', { fg = colors.number })
    hl('Boolean', { fg = colors.number })
    hl('Float', { fg = colors.number })
    hl('Identifier', { fg = colors.class_name })
    hl('Function', { fg = colors.function_name })
    hl('Statement', { fg = colors.keyword })
    hl('Conditional', { fg = colors.keyword })
    hl('Repeat', { fg = colors.keyword })
    hl('Label', { fg = colors.keyword, underline = true })
    hl('Operator', { fg = colors.operator })
    hl('Keyword', { fg = colors.keyword })
    hl('Exception', { fg = colors.keyword })
    hl('PreProc', { fg = colors.keyword })
    hl('Include', { fg = colors.keyword })
    hl('Define', { fg = colors.keyword })
    hl('Macro', { fg = colors.keyword })
    hl('PreCondit', { fg = colors.keyword })
    hl('Type', { fg = colors.class_name })
    hl('StorageClass', { fg = colors.keyword })
    hl('Structure', { fg = colors.class_name })
    hl('Typedef', { fg = colors.class_name })
    hl('Special', { fg = colors.attribute })
    hl('SpecialChar', { fg = colors.attribute })
    hl('Tag', { fg = colors.keyword })
    hl('Delimiter', { fg = colors.operator })
    hl('SpecialComment', { fg = colors.doc_comment, italic = true })
    hl('Debug', { fg = colors.error })
    hl('Underlined', { underline = true })
    hl('Ignore', { fg = colors.doc_comment })
    hl('Error', { fg = colors.error, undercurl = true, sp = colors.error })
    hl('Todo', { fg = colors.info, bold = true })

    -- Diagnostics
    hl('DiagnosticError', { fg = colors.error })
    hl('DiagnosticWarn', { fg = colors.warning })
    hl('DiagnosticInfo', { fg = colors.info })
    hl('DiagnosticHint', { fg = colors.hint })
    hl('DiagnosticUnderlineError', { undercurl = true, sp = colors.error })
    hl('DiagnosticUnderlineWarn', { undercurl = true, sp = colors.warning })
    hl('DiagnosticUnderlineInfo', { undercurl = true, sp = colors.info })
    hl('DiagnosticUnderlineHint', { undercurl = true, sp = colors.hint })

    -- Treesitter
    hl('@comment', { link = 'Comment' })
    hl('@constant', { link = 'Constant' })
    hl('@constant.builtin', { fg = colors.constant, italic = true })
    hl('@string', { link = 'String' })
    hl('@number', { link = 'Number' })
    hl('@boolean', { link = 'Boolean' })
    hl('@function', { fg = colors.function_name })
    hl('@function.call', { fg = colors.function_call })
    hl('@function.builtin', { fg = colors.function_name })
    hl('@function.method', { fg = colors.function_call })
    hl('@function.method.call', { fg = colors.function_call })
    hl('@keyword', { link = 'Keyword' })
    hl('@keyword.function', { link = 'Keyword' })
    hl('@keyword.operator', { link = 'Keyword' })
    hl('@keyword.return', { link = 'Keyword' })
    hl('@operator', { link = 'Operator' })
    hl('@type', { fg = colors.class_name })
    hl('@type.builtin', { fg = colors.class_name })
    hl('@type.definition', { fg = colors.class_name })
    hl('@variable', { fg = colors.fg })
    hl('@variable.builtin', { fg = colors.constant, italic = true })
    hl('@variable.parameter', { fg = colors.fg })
    hl('@property', { fg = colors.instance_field })
    hl('@field', { fg = colors.instance_field })
    hl('@constructor', { fg = colors.class_name })
    hl('@namespace', { fg = colors.class_name })
    hl('@tag', { fg = colors.keyword })
    hl('@tag.attribute', { fg = colors.attribute })
    hl('@tag.delimiter', { fg = colors.operator })
    hl('@attribute', { fg = colors.attribute })
    hl('@label', { link = 'Label' })
    hl('@punctuation.bracket', { fg = colors.operator })
    hl('@punctuation.delimiter', { fg = colors.operator })

    -- LSP Semantic Tokens
    hl('@lsp.type.class', { fg = colors.class_name })
    hl('@lsp.type.decorator', { fg = colors.attribute })
    hl('@lsp.type.enum', { fg = colors.class_name })
    hl('@lsp.type.enumMember', { fg = colors.constant })
    hl('@lsp.type.function', { fg = colors.function_name })
    hl('@lsp.type.interface', { fg = colors.class_name })
    hl('@lsp.type.macro', { fg = colors.keyword })
    hl('@lsp.type.method', { fg = colors.function_call })
    hl('@lsp.type.namespace', { fg = colors.class_name })
    hl('@lsp.type.parameter', { fg = colors.fg })
    hl('@lsp.type.property', { fg = colors.instance_field })
    hl('@lsp.type.struct', { fg = colors.class_name })
    hl('@lsp.type.type', { fg = colors.class_name })
    hl('@lsp.type.typeParameter', { fg = colors.class_name })
    hl('@lsp.type.variable', { fg = colors.fg })
    hl('@lsp.mod.readonly', { fg = colors.constant })
    hl('@lsp.mod.deprecated', { fg = colors.warning, strikethrough = true })

    -- Git signs
    hl('GitSignsAdd', { fg = colors.console_green, bg = colors.gutter_bg })
    hl('GitSignsChange', { fg = colors.console_yellow, bg = colors.gutter_bg })
    hl('GitSignsDelete', { fg = colors.console_red, bg = colors.gutter_bg })

    -- Diff
    hl('DiffAdd', { bg = colors.diff_add })
    hl('DiffChange', { bg = colors.coverage_partial })
    hl('DiffDelete', { bg = colors.diff_delete })
    hl('DiffText', { bg = colors.selection_bg })

    -- Markdown
    hl('markdownCode', { fg = colors.markdown_code, italic = true })
    hl('markdownCodeBlock', { fg = colors.markdown_code })
    hl('@markup.raw', { fg = colors.markdown_code, italic = true })
    hl('@markup.heading', { fg = colors.keyword, bold = true })
    hl('@markup.link', { fg = colors.keyword, underline = true })
    hl('@markup.link.url', { fg = colors.keyword, underline = true })

    -- JSON
    hl('jsonKeyword', { fg = colors.json_property })
    hl('jsonBraces', { fg = colors.json_punctuation })
    hl('jsonBrackets', { fg = colors.json_punctuation })
    hl('@property.json', { fg = colors.json_property })
    hl('@punctuation.bracket.json', { fg = colors.json_punctuation })

    -- PHP specific (if using Treesitter)
    hl('@variable.member.php', { fg = colors.instance_field })
    hl('@constant.php', { fg = colors.constant, bold = true })
    hl('@type.php', { fg = colors.class_name })

    -- Telescope (fuzzy finder)
    hl('TelescopeNormal', { fg = colors.fg, bg = colors.bg })
    hl('TelescopeSelection', { bg = colors.selection_bg })
    hl('TelescopeMatching', { fg = colors.function_call, bold = true })

    -- NvimTree / Neo-tree
    hl('NvimTreeNormal', { fg = colors.fg, bg = colors.bg })
    hl('NvimTreeFolderName', { fg = colors.keyword })
    hl('NvimTreeOpenedFolderName', { fg = colors.keyword, bold = true })
    hl('NvimTreeRootFolder', { fg = colors.class_name, bold = true })
    hl('NvimTreeSpecialFile', { fg = colors.function_call })

    -- WhichKey
    hl('WhichKey', { fg = colors.keyword })
    hl('WhichKeyGroup', { fg = colors.class_name })
    hl('WhichKeyDesc', { fg = colors.fg })

    -- Inline hints
    hl('LspInlayHint', { fg = colors.parameter_hint_fg, bg = colors.parameter_hint_bg, italic = true })
end

return M
