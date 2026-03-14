local icons = require('danyelkeddah.icons')
return {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    enabled = false,
    dependencies = {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-nvim-lsp-signature-help',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        { 'L3MON4D3/LuaSnip', build = 'make install_jsregexp' },
        'saadparwaiz1/cmp_luasnip',
        { 'roobert/tailwindcss-colorizer-cmp.nvim', config = true },
    },
    config = function()
        local cmp = require('cmp')
        local ls = require('luasnip')
        cmp.setup({
            completion = {
                completeopt = 'menu,menuone',
            },
            window = {
                documentation = {
                    winhighlight = 'Normal:CmpDoc',
                },
            },
            sources = {
                { name = 'nvim_lsp' },
                { name = 'nvim_lsp_signature_help' },
                { name = 'luasnip' },
                { name = 'path' },
                { name = 'buffer' },
                { name = 'lazydev' },
            },
            formatting = {
                fields = { 'kind', 'abbr', 'menu' },
                format = function(entry, item)
                    if icons.kind[item.kind] then
                        item.kind = icons.kind[item.kind] .. ' ' .. item.kind
                    end

                    local widths = {
                        abbr = vim.g.cmp_widths and vim.g.cmp_widths.abbr or 40,
                        menu = vim.g.cmp_widths and vim.g.cmp_widths.menu or 30,
                    }

                    for key, width in pairs(widths) do
                        if item[key] and vim.fn.strdisplaywidth(item[key]) > width then
                            item[key] = vim.fn.strcharpart(item[key], 0, width - 1) .. '…'
                        end
                    end
                    return item
                end,
            },
            snippet = {
                expand = function(args)
                    ls.lsp_expand(args.body)
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
                ['<Tab>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                ['<S-Tab>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
                ['<C-Space>'] = cmp.mapping.complete(), -- show completion suggestions
                ['<CR>'] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Insert }, { 'i', 'c' }),
                ['<C-y>'] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Insert }, { 'i', 'c' }),
            }),
        })
        cmp.setup.filetype({ 'sql' }, {
            sources = {
                { name = 'vim-dadbod-completion' },
                { name = 'buffer' },
            },
        })

        ls.config.set_config({
            history = false,
            updateevents = 'TextChanged,TextChangedI',
        })
        local snippets_folder = vim.fn.stdpath('config') .. '/lua/danyelkeddah/snippets/'
        require('luasnip.loaders.from_vscode').load({
            paths = snippets_folder,
        })

        vim.keymap.set({ 'i', 's' }, '<c-k>', function()
            if ls.expand_or_jumpable() then
                ls.expand_or_jump()
            end
        end, { silent = true })
        vim.keymap.set({ 'i', 's' }, '<c-j>', function()
            if ls.jumpable(-1) then
                ls.jump(-1)
            end
        end, { silent = true })
    end,
}
