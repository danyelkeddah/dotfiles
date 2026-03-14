return {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    -- stylua: ignore
    keys = {
        { '<leader>H', function() require('harpoon'):list():add() end, desc = 'Harpoon File' },
        { '<leader>hh', function() local harpoon = require('harpoon'); harpoon.ui:toggle_quick_menu(harpoon:list()) end, desc = 'Harpoon Quick Menu' },
    },
    config = function()
        local harpoon = require('harpoon')
        harpoon:setup()
        for _, idx in ipairs({ 1, 2, 3, 4, 5 }) do
            -- stylua: ignore
            vim.keymap.set('n', string.format('<space>%d', idx), function() harpoon:list():select(idx) end)
        end
    end,
}
