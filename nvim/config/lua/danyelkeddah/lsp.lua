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

vim.diagnostic.config({
    severity_sort = true,
    underline = { severity = vim.diagnostic.severity.ERROR },
    virtual_text = {
        spacing = 2,
        prefix = '●',
        source = 'if_many',
    },
    signs = false,
    float = {
        border = 'rounded',
        source = 'if_many',
    },
})

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('danyelkeddah_lsp_attach', { clear = true }),
    callback = function(args)
        local bufnr = args.buf
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id), 'must have a valid client')
        vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

        -- Formatting is delegated entirely to conform.nvim; strip the capability so no LSP ever formats.
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false

        local map = function(mode, lhs, rhs, desc, opts)
            opts = vim.tbl_extend('force', { buffer = bufnr, desc = desc }, opts or {})
            vim.keymap.set(mode, lhs, rhs, opts)
        end

        map('n', 'gr', vim.lsp.buf.references, 'References', { nowait = true })
        map('n', 'gI', vim.lsp.buf.implementation, 'Goto Implementation')
        map('n', 'gT', vim.lsp.buf.type_definition, 'Goto Type Definition')
        map('n', 'gK', vim.lsp.buf.signature_help, 'Signature Help')
        map('i', '<C-k>', vim.lsp.buf.signature_help, 'Signature Help')
        map({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, 'Code Action')
        map({ 'n', 'v' }, '<leader>cc', vim.lsp.codelens.run, 'Run Codelens')
        map('n', '<leader>cC', vim.lsp.codelens.refresh, 'Refresh & Display Codelens')
        map('n', '<leader>cr', vim.lsp.buf.rename, 'Rename')
        map('n', '<leader>cA', function()
            vim.lsp.buf.code_action({
                apply = true,
                context = { only = { 'source' }, diagnostics = {} },
            })
        end, 'Source Action')

        if client:supports_method('textDocument/inlayHint') then
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
            map('n', '<leader>uh', function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
            end, 'Toggle Inlay Hints')
        end
    end,
})
