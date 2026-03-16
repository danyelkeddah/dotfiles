local ensure_installed = { 'bash', 'python', 'query', 'regex', 'vim', 'vimdoc', 'diff', 'gitattributes', 'gitignore', 'gitcommit', 'git_config', 'git_rebase', 'graphql', 'jq', 'make', 'solidity', 'sql', 'ini', 'css', 'scss', 'dockerfile', 'go', 'gomod', 'gowork', 'gosum', 'html', 'twig', 'json', 'json5', 'jsonc', 'lua', 'luadoc', 'luap', 'markdown', 'markdown_inline', 'mermaid', 'php', 'phpdoc', 'terraform', 'hcl', 'javascript', 'typescript', 'tsx', 'vue', 'yaml', 'http' }

return {
    'nvim-treesitter/nvim-treesitter',
    version = false,
    build = ':TSUpdate',
    dependencies = {
        'windwp/nvim-ts-autotag',
        -- { 'nvim-treesitter/nvim-treesitter-textobjects', after = 'nvim-treesitter' },
        { 'whatyouhide/vim-textobj-xmlattr', dependencies = 'kana/vim-textobj-user' },
        { 'JoosepAlviste/nvim-ts-context-commentstring', opts = { enable_autocmd = false } },
    },
    config = function()
        require('nvim-treesitter.config').setup({
            install_dir = vim.fn.stdpath('data') .. '/treesitter',
            auto_install = true,
            ignore_install = {},
            modules = {},
            sync_install = false,
            ensure_installed = ensure_installed,
            highlight = { enable = true, additional_vim_regex_highlighting = false },
            indent = { enable = true },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = '<C-space>',
                    node_incremental = '<C-space>',
                    scope_incremental = false,
                    node_decremental = '<bs>',
                },
            },
            textobjects = {
                select = {
                    enable = true,
                    lookahead = true,
                },
                move = {
                    enable = true,
                    goto_previous_start = {
                        ['[f'] = { query = '@function.outer', desc = 'Previous function' },
                        ['[c'] = { query = '@class.outer', desc = 'Previous class' },
                        ['[p'] = { query = '@parameter.outer', desc = 'Previous parameter' },
                    },
                    goto_next_start = {
                        [']f'] = { query = '@function.outer', desc = 'Next function' },
                        [']c'] = { query = '@class.outer', desc = 'Next class' },
                        [']p'] = { query = '@parameter.outer', desc = 'Next parameter' },
                    },
                    goto_previous_end = {
                        ['[F'] = { query = '@function.outer', desc = 'Previous function end' },
                        ['[C'] = { query = '@class.outer', desc = 'Previous class end' },
                        ['[P'] = { query = '@parameter.outer', desc = 'Previous parameter end' },
                    },
                    goto_next_end = {
                        [']F'] = { query = '@function.outer', desc = 'Next function end' },
                        [']C'] = { query = '@class.outer', desc = 'Next class end' },
                        [']P'] = { query = '@parameter.outer', desc = 'Next parameter end' },
                    },
                },
            },
        })
    end,
}
