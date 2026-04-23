require('nvim-treesitter').setup({
    install_dir = vim.fn.stdpath('data') .. '/treesitter',
})

require('nvim-treesitter').install({
    'bash', 'css', 'diff', 'dockerfile', 'git_config', 'git_rebase',
    'gitattributes', 'gitcommit', 'gitignore', 'go', 'gomod', 'gosum',
    'gowork', 'graphql', 'hcl', 'html', 'http', 'ini', 'javascript',
    'jq', 'json', 'json5', 'lua', 'luadoc', 'luap', 'make',
    'markdown', 'markdown_inline', 'mermaid', 'php', 'phpdoc', 'python',
    'query', 'regex', 'scss', 'solidity', 'sql', 'terraform', 'tsx',
    'twig', 'typescript', 'vim', 'vimdoc', 'vue', 'yaml',
})

vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('TreesitterStart', { clear = true }),
    callback = function(event)
        local buf = event.buf
        local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
        if lang and pcall(vim.treesitter.start, buf, lang) then
            vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
    end,
})
