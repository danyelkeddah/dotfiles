vim.api.nvim_create_autocmd('PackChanged', {
    group = vim.api.nvim_create_augroup('PhpactorBuild', { clear = true }),
    callback = function(args)
        local data = args.data
        if data.spec.name ~= 'phpactor' then
            return
        end
        if data.kind == 'install' or data.kind == 'update' then
            vim.system(
                { 'composer', 'install', '--no-dev', '--optimize-autoloader' },
                { cwd = data.path },
                vim.schedule_wrap(function(obj)
                    if obj.code ~= 0 then
                        vim.notify('phpactor: composer install failed\n' .. (obj.stderr or ''), vim.log.levels.ERROR)
                    end
                end)
            )
        end
    end,
})

vim.api.nvim_create_autocmd('FileType', {
    pattern = 'php',
    group = vim.api.nvim_create_augroup('PhpactorKeymaps', { clear = true }),
    callback = function(args)
        vim.keymap.set('n', '<Leader>pm', '<cmd>PhpactorContextMenu<cr>', { buffer = args.buf, desc = 'Phpactor context menu' })
        vim.keymap.set('n', '<Leader>pn', '<cmd>PhpactorClassNew<cr>', { buffer = args.buf, desc = 'Phpactor new class' })
    end,
})
