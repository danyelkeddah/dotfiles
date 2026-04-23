vim.api.nvim_create_autocmd('PackChanged', {
    group = vim.api.nvim_create_augroup('LuaSnipBuild', { clear = true }),
    callback = function(args)
        local data = args.data
        if data.spec.name ~= 'LuaSnip' then
            return
        end
        if data.kind == 'install' or data.kind == 'update' then
            vim.system(
                { 'make', 'install_jsregexp' },
                { cwd = data.path },
                vim.schedule_wrap(function(obj)
                    if obj.code ~= 0 then
                        vim.notify('LuaSnip: make install_jsregexp failed\n' .. (obj.stderr or ''), vim.log.levels.ERROR)
                    end
                end)
            )
        end
    end,
})

require('blink.cmp').setup({
    keymap = {
        preset = 'enter',
        ['<Tab>'] = {
            function(cmp)
                if cmp.snippet_active() then
                    return cmp.accept()
                else
                    return cmp.select_and_accept()
                end
            end,
            'snippet_forward',
            'fallback',
        },
    },
    signature = { enabled = true },
    sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
        per_filetype = {
            gitcommit = { 'git', 'buffer' },
        },
        providers = {
            git = { module = 'blink-cmp-git', name = 'Git' },
        },
    },
    completion = {
        documentation = {
            auto_show = true,
            auto_show_delay_ms = 200,
        },
        menu = {
            draw = {
                components = {
                    kind_icon = {
                        text = function(ctx)
                            return (require('mini.icons').get('lsp', ctx.kind))
                        end,
                        highlight = function(ctx)
                            local _, hl = require('mini.icons').get('lsp', ctx.kind)
                            return hl
                        end,
                    },
                    kind = {
                        highlight = function(ctx)
                            local _, hl = require('mini.icons').get('lsp', ctx.kind)
                            return hl
                        end,
                    },
                },
            },
        },
    },
})
