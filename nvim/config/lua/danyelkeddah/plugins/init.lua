local icons = require('danyelkeddah.icons')
local M = {}

-- stylua: ignore start
table.insert(M, { 'nvim-lua/plenary.nvim' })                                                                      -- lua functions that many plugins use
table.insert(M, { 'tpope/vim-repeat', event = 'VeryLazy' })                                                       -- Enable repeating supported plugin maps with "."
table.insert(M, { 'lilydjwg/colorizer' })                                                                         -- Colorize all text in the form #rrggbb or #rgb.
table.insert(M, { 'christoomey/vim-tmux-navigator' })                                                             -- Seamless navigation between tmux panes and vim splits
table.insert(M, { 'tpope/vim-dotenv' })                                                                           -- .env
table.insert(M, { 'MunifTanjim/nui.nvim', lazy = true })                                                          -- ui components
table.insert(M, { 'ku1ik/vim-pasta', config = function() vim.g.pasta_disabled_filetypes = { 'fugitive', } end }) -- Automatically fix indentation when pasting code.
table.insert(M, { 'nvim-tree/nvim-web-devicons', config = function() require('nvim-web-devicons').setup({ override = icons.devicons }) end })
table.insert(M, { 'stevearc/dressing.nvim' })
table.insert(M, { 'folke/lazydev.nvim' })
table.insert(M, { 'meznaric/key-analyzer.nvim', cmd = { 'KeyAnalyzer' }})
table.insert(M, { 'b0o/SchemaStore.nvim' })


return M
