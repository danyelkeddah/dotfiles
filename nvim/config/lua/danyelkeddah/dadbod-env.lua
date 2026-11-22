local M = {}
local projects, managed, published = {}, {}, {}

local function notify(message)
    vim.notify(message, vim.log.levels.INFO, { title = 'Dadbod' })
end

-- Resolve from the file, never from an unrelated window's working directory.
local function env_file(buf, directory)
    if not directory then
        if vim.bo[buf].buftype ~= '' then return end
        local name = vim.api.nvim_buf_get_name(buf)
        if name == '' or name:match('^%w+://') then return end
        directory = vim.fs.dirname(name)
    end
    directory = vim.fs.normalize(vim.fn.fnamemodify(directory, ':p'))
    while directory do
        local file = directory .. '/.env'
        if vim.fn.filereadable(file) == 1 then return file end
        -- Do not inherit credentials from outside a repository.
        if vim.uv.fs_stat(directory .. '/.git') then return end
        local parent = vim.fs.dirname(directory)
        if parent == directory then return end
        directory = parent
    end
end

local function publish()
    -- Preserve existing user-configured connections (dictionary or list).
    local entries = {}
    local existing = vim.g.dbs or {}
    if vim.islist(existing) then
        for _, entry in ipairs(existing) do
            if published[entry.name] ~= entry.url then entries[#entries + 1] = entry end
        end
    else
        for name, url in pairs(existing) do
            if published[name] ~= url then entries[#entries + 1] = { name = name, url = url } end
        end
    end
    published = {}
    local names = {}
    for _, entry in ipairs(entries) do names[entry.name] = true end
    for file, project in pairs(projects) do
        for name, url in pairs(project.connections) do
            local label = vim.fs.dirname(file) .. ' :: ' .. name
            if not names[label] then
                entries[#entries + 1] = { name = label, url = url }
                published[label] = url
                names[label] = true
            end
        end
    end
    vim.g.dbs = entries
end

local function discover(file)
    if vim.fn.exists('*DotenvRead') ~= 1 then return end
    local ok, env = pcall(vim.fn.DotenvRead, file)
    if not ok then
        notify('Could not parse project .env')
        return
    end
    local connections = {}
    for key, url in pairs(env) do
        local name = key:match('^DADBOD_DB_([%w_]+)$')
        if name and type(url) == 'string' and url ~= '' then connections[name] = url end
    end
    if vim.tbl_isempty(connections) and env.DATABASE_URL and env.DATABASE_URL ~= '' then
        connections.DEFAULT = env.DATABASE_URL
    end
    local project = projects[file] or {}
    local changed = not vim.deep_equal(project.connections, connections)
    project.connections = connections
    if not connections[project.selected] then project.selected = nil end
    if vim.tbl_count(connections) == 1 then project.selected = next(connections) end
    projects[file] = project
    if changed then publish() end
    return project
end

local function assign(buf, file, name, override)
    local url = name and projects[file].connections[name] or nil
    local previous = vim.b[buf].db
    if previous ~= url then
        vim.b[buf].db = url
        -- Completion caches its connection by buffer; invalidate on selection.
        if vim.fn.exists('*vim_dadbod_completion#clear_cache') == 1 then
            vim.fn['vim_dadbod_completion#clear_cache']()
        end
    end
    managed[buf] = { file = file, name = name, url = url, override = override }
end

function M.refresh(buf)
    buf = buf or vim.api.nvim_get_current_buf()
    if not vim.api.nvim_buf_is_valid(buf) then return end
    local state = managed[buf]
    -- Never overwrite DBUI's own association or a manually assigned b:db.
    if vim.b[buf].dbui_db_key_name ~= nil and vim.b[buf].dbui_db_key_name ~= '' then return end
    if vim.b[buf].db ~= nil and (not state or vim.b[buf].db ~= state.url) then
        managed[buf] = nil
        return
    end
    local file = env_file(buf)
    if not file and state and state.explicit then file = state.file end
    if not file then
        if state then assign(buf, state.file, nil, false); managed[buf] = nil end
        return
    end
    local project = discover(file)
    if not project then return end
    local override = state and state.file == file and state.override
    local name = override and state.name or project.selected
    if not project.connections[name] then name = project.selected; override = false end
    local explicit = state and state.explicit
    assign(buf, file, name, override)
    managed[buf].explicit = explicit
end

function M.select(opts)
    local buf = vim.api.nvim_get_current_buf()
    local file = env_file(buf, opts.args ~= '' and vim.fn.expand(opts.args) or nil)
    if not file then
        notify('No project .env found. Use :DadbodSelect /path/to/project for unnamed/special buffers.')
        return
    end
    local project = discover(file)
    if not project or vim.tbl_isempty(project.connections) then
        notify('No DADBOD_DB_* connections or DATABASE_URL found in project .env.')
        return
    end
    if vim.b[buf].dbui_db_key_name and vim.b[buf].dbui_db_key_name ~= '' then
        notify('This buffer belongs to DBUI. Select its connection in DBUI instead.')
        return
    end
    local names = vim.tbl_keys(project.connections)
    table.sort(names)
    vim.ui.select(names, {
        prompt = opts.bang and 'Database for this buffer:' or 'Database for this project:',
    }, function(name)
        if not name or not vim.api.nvim_buf_is_valid(buf) then return end
        if not opts.bang then project.selected = name end
        assign(buf, file, name, opts.bang)
        managed[buf].explicit = opts.args ~= ''
        if not opts.bang then
            for _, other in ipairs(vim.api.nvim_list_bufs()) do
                if other ~= buf and vim.api.nvim_buf_is_loaded(other) then M.refresh(other) end
            end
        end
        if (vim.w.db and vim.w.db ~= '') or (vim.t.db and vim.t.db ~= '') then
            notify('Selected ' .. name .. '; existing w:db or t:db takes precedence. Clear it to use this selection.')
        else
            notify('Selected ' .. name .. (opts.bang and ' for this buffer' or ' for this project (session)'))
        end
    end)
end

function M.setup()
    vim.api.nvim_create_user_command('DadbodSelect', M.select, { bang = true, nargs = '?', complete = 'dir', force = true })
    vim.api.nvim_create_user_command('DadbodRefresh', function()
        for file in pairs(projects) do discover(file) end
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_loaded(buf) then M.refresh(buf) end
        end
    end, { force = true })
    local group = vim.api.nvim_create_augroup('DadbodDotenv', { clear = true })
    vim.api.nvim_create_autocmd({ 'BufEnter', 'BufFilePost' }, {
        group = group,
        callback = function(event) M.refresh(event.buf) end,
    })
    vim.api.nvim_create_autocmd('BufWritePost', {
        group = group, pattern = '.env',
        callback = function() vim.cmd('DadbodRefresh') end,
    })
    vim.api.nvim_create_autocmd('BufWipeout', {
        group = group, callback = function(event) managed[event.buf] = nil end,
    })
    M.refresh()
end

return M
