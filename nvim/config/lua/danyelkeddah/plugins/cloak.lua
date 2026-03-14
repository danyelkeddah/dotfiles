return {
    'laytan/cloak.nvim',
    config = function()
        require('cloak').setup({
            enabled = true,
        })
    end,
}
