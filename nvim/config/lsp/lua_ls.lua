return {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    root_markers = { '.luarc.json', '.luarc.jsonc', '.luacheckrc', '.stylua.toml', 'stylua.toml', 'selene.toml', 'selene.yml', '.git' },
    log_level = vim.lsp.protocol.MessageType.Warning,
    settings = {
        Lua = {
            runtime = { version = 'LuaJIT' },
            diagnostics = {
                globals = { 'vim', 'hs', 'Snacks' },
            },
            completion = {
                callSnippet = 'Replace',
            },
            telemetry = {
                enable = false,
            },
            workspace = {
                checkThirdParty = false,
                library = table.insert(vim.api.nvim_get_runtime_file('', true), {
                    [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                    [vim.fn.stdpath('config') .. '/lua'] = true,
                    [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
                    ['/Applications/Hammerspoon.app/Contents/Resources/extensions/hs/'] = true,
                }),
            },
        },
    },
}
