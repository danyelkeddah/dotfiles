vim.pack.add({
    { src = 'https://github.com/catppuccin/nvim', name = 'catppuccin' },
    { src = 'https://github.com/nvim-lua/plenary.nvim' },
    -- { src = 'https://github.com/tpope/vim-repeat' },
    { src = 'https://github.com/christoomey/vim-tmux-navigator' },
    -- { src = 'https://github.com/tpope/vim-dotenv' },
    -- { src = 'https://github.com/MunifTanjim/nui.nvim' },
    -- { src = 'https://github.com/ku1ik/vim-pasta' },
    { src = 'https://github.com/nvim-tree/nvim-web-devicons' },
    -- { src = 'https://github.com/stevearc/dressing.nvim' },
    -- { src = 'https://github.com/meznaric/key-analyzer.nvim' },
    -- { src = 'https://github.com/b0o/SchemaStore.nvim' },
    { src = 'https://github.com/tpope/vim-fugitive' },
    { src = 'https://github.com/tpope/vim-rhubarb' },
    { src = 'https://github.com/laytan/cloak.nvim' },
    { src = 'https://github.com/MagicDuck/grug-far.nvim' },
    { src = 'https://github.com/stevearc/oil.nvim' },
    { src = 'https://github.com/stevearc/conform.nvim' },
    { src = 'https://github.com/mfussenegger/nvim-lint' },
    { src = 'https://github.com/phpactor/phpactor' },
    { src = 'https://github.com/MeanderingProgrammer/render-markdown.nvim' },
    { src = 'https://github.com/echasnovski/mini.icons' },
    { src = 'https://github.com/folke/snacks.nvim' },
    { src = 'https://github.com/b0o/SchemaStore.nvim' },
    { src = 'https://github.com/folke/lazydev.nvim' },
    { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range('*') },
    { src = 'https://github.com/Kaiser-Yang/blink-cmp-git' },
    { src = 'https://github.com/L3MON4D3/LuaSnip' },
    { src = 'https://github.com/lewis6991/gitsigns.nvim' },
    { src = 'https://github.com/williamboman/mason.nvim' },
    { src = 'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim' },
    { src = 'https://github.com/j-hui/fidget.nvim' },
    { src = 'https://github.com/echasnovski/mini.ai' },
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter' },
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects', version = 'main' },
    { src = 'https://github.com/windwp/nvim-ts-autotag' },
    { src = 'https://github.com/folke/ts-comments.nvim' },
    { src = 'https://github.com/kana/vim-textobj-user' },
    { src = 'https://github.com/whatyouhide/vim-textobj-xmlattr' },
    { src = 'https://github.com/echasnovski/mini.pairs' },
    { src = 'https://github.com/echasnovski/mini.splitjoin' },
    { src = 'https://github.com/echasnovski/mini.statusline' },
    { src = 'https://github.com/echasnovski/mini.surround' },
    { src = 'https://github.com/folke/tokyonight.nvim' },
    { src = 'https://github.com/sainnhe/gruvbox-material' },
})

require('danyelkeddah.plugins.catppuccin')
require('danyelkeddah.plugins.vim-fugitive')
require('danyelkeddah.plugins.cloak')
require('danyelkeddah.plugins.grug-far')
require('danyelkeddah.plugins.oil')
require('danyelkeddah.plugins.conform')
require('danyelkeddah.plugins.nvim-lint')
require('danyelkeddah.plugins.phpactor')
require('danyelkeddah.plugins.render-markdown')
require('danyelkeddah.plugins.undotree')
require('danyelkeddah.plugins.snacks')
require('danyelkeddah.plugins.lazydev')
require('danyelkeddah.plugins.blink-cmp')
require('danyelkeddah.plugins.gitsigns')
require('danyelkeddah.plugins.mason')
require('danyelkeddah.plugins.fidget')
require('danyelkeddah.plugins.mini-ai')
require('danyelkeddah.plugins.nvim-treesitter')
require('danyelkeddah.plugins.nvim-ts-autotag')
require('danyelkeddah.plugins.ts-comments')
require('danyelkeddah.plugins.mini-pairs')
require('danyelkeddah.plugins.mini-splitjoin')
require('danyelkeddah.plugins.mini-statusline')
require('danyelkeddah.plugins.mini-surround')
require('danyelkeddah.plugins.tokyonight')
require('danyelkeddah.plugins.gruvbox-material')
