vim.g.db_ui_use_nerd_fonts = 1
vim.g.db_ui_env_variable_url = 'DATABASE_URL'

require('danyelkeddah.dadbod-env').setup()

vim.keymap.set('n', '<leader>du', '<cmd>DBUIToggle<cr>', { desc = 'Database UI' })
vim.keymap.set('n', '<leader>ds', '<cmd>DadbodSelect<cr>', { desc = 'Select project database' })
