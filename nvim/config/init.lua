require('danyelkeddah.options')
require('danyelkeddah.keymaps')
require('danyelkeddah.autocmds')

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
    spec = {
        { import = 'danyelkeddah.plugins' },
    },
    ui = {
        icons = {
            ft = '',
            lazy = '󰂠 ',
            loaded = '',
            not_loaded = '',
        },
    },
    install = {
        missing = true,
        colorscheme = { 'tokyonight' },
    },
    change_detection = {
        notify = false,
    },
})

vim.keymap.set('n', '<leader>l', '<cmd>:Lazy<cr>', { desc = 'Plugin Manager (Lazy)' })

--automatically enable all lsps
local configs = {}
for _, v in ipairs(vim.api.nvim_get_runtime_file('lsp/*', true)) do
    local name = vim.fn.fnamemodify(v, ':t:r')
    configs[name] = true
end
vim.lsp.enable(vim.tbl_keys(configs))
-- vim.lsp.enable({ 'html' })

vim.lsp.config('*', {
    -- capabilities = require('cmp_nvim_lsp').default_capabilities(),
    capabilities = require('blink.cmp').get_lsp_capabilities(),
})
