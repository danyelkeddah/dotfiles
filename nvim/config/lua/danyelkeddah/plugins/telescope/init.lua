return {
    'nvim-telescope/telescope.nvim',
    enabled = true,
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope-live-grep-args.nvim',
        'nvim-telescope/telescope-ui-select.nvim',
        'cappyzawa/telescope-terraform.nvim',
        'ANGkeith/telescope-terraform-doc.nvim',
        {
            'nvim-telescope/telescope-fzf-native.nvim',
            build = 'make',
        },
    },
    cmd = 'Telescope',
    keys = require('danyelkeddah.plugins.telescope.keymaps'),
    config = function()
        require('telescope').setup({
            defaults = require('danyelkeddah.plugins.telescope.defaults'),
            pickers = require('danyelkeddah.plugins.telescope.pickers'),
            extensions = require('danyelkeddah.plugins.telescope.extensions'),
        })
        pcall(require('telescope').load_extension, 'fzf')
        pcall(require('telescope').load_extension, 'ui-select')
        pcall(require('telescope').load_extension, 'live_grep_args')
        pcall(require('telescope').load_extension, 'terraform_doc')
        pcall(require('telescope').load_extension, 'terraform')
        pcall(require('telescope').load_extension, 'notify')
    end,
}
