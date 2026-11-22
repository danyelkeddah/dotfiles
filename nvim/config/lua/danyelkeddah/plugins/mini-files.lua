local files = require('mini.files')

files.setup({
    content = {
        filter = function(entry)
            return entry.name ~= '.git'
        end,
    },
    options = {
        permanent_delete = false,
    },
})

local toggle = function(path)
    if not files.close() then
        files.open(path)
    end
end

vim.keymap.set('n', '<Leader>e', function()
    local path = vim.api.nvim_buf_get_name(0)
    toggle(path ~= '' and path or vim.uv.cwd())
end, { desc = 'Explorer (current file)' })

vim.keymap.set('n', '<Leader>E', function()
    toggle(vim.uv.cwd())
end, { desc = 'Explorer (cwd)' })
