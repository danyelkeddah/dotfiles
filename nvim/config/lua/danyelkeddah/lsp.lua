vim.lsp.enable({
    'ansiblels',
    'cssls',
    'docker_compose_language_service',
    'dockerls',
    'emmet_ls',
    'gopls',
    'html',
    'intelephense',
    'jsonls',
    'lua_ls',
    'marksman',
    'tailwindcss',
    'terraformls',
    'ts_ls',
    'yamlls',
})

-- Auto Discovery
-- local configs = {}
-- for _, v in ipairs(vim.api.nvim_get_runtime_file('lsp/*', true)) do
--     local name = vim.fn.fnamemodify(v, ':t:r')
--     configs[name] = true
-- end
-- vim.lsp.enable(vim.tbl_keys(configs))
