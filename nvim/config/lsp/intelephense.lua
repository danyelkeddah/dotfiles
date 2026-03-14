return {
    cmd = { 'intelephense', '--stdio' },
    filetypes = { 'php' },
    root_markers = { 'composer.json', '.git' },
    init_options = {
        -- globalStoragePath = os.getenv('HOME') .. '/.config/intelephense',
        licenceKey = os.getenv('HOME') .. '/.config/intelephense/license.txt',
    },
    commands = {
        IntelephenseIndex = {
            function()
                vim.lsp.buf.execute_command({ command = 'intelephense.index.workspace' })
            end,
        },
    },
}
