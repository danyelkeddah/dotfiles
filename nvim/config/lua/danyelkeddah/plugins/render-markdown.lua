require('render-markdown').setup({
    bullet = {
        right_pad = 1,
    },
})

local function set_heading_highlights()
    local ok, palettes = pcall(require, 'catppuccin.palettes')
    if not ok then
        return
    end
    local c = palettes.get_palette()
    local fgs = { c.red, c.peach, c.yellow, c.green, c.teal, c.blue }
    for i, fg in ipairs(fgs) do
        vim.api.nvim_set_hl(0, 'RenderMarkdownH' .. i, { fg = fg, bold = true })
        vim.api.nvim_set_hl(0, 'RenderMarkdownH' .. i .. 'Bg', { bg = c.surface0 })
    end
end

-- survive colorscheme reloads
vim.api.nvim_create_autocmd('ColorScheme', {
    group = vim.api.nvim_create_augroup('RenderMarkdownHighlights', { clear = true }),
    callback = set_heading_highlights,
})

-- catch the startup fire we missed
set_heading_highlights()
