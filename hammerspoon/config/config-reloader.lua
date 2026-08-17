local M = {}

local reloadTimer

local function validateConfig()
    for file in hs.fs.dir(hs.configdir) do
        if file:match("%.lua$") then
            local path = hs.configdir .. "/" .. file
            local chunk, syntaxError = loadfile(path)
            if not chunk then
                local message = syntaxError:gsub(hs.configdir .. "/", "")
                print("Hammerspoon config not reloaded: " .. message)
                hs.alert.show("Config error\n" .. message, nil, nil, 5)
                return false
            end
        end
    end

    return true
end

local function reloadConfig()
    if validateConfig() then
        hs.reload()
    end
end

local function scheduleReload(changedFiles)
    for _, path in ipairs(changedFiles) do
        if path:match("%.lua$") then
            if reloadTimer then
                reloadTimer:stop()
            end

            reloadTimer = hs.timer.doAfter(0.25, reloadConfig)
            return
        end
    end
end

function M.start()
    M.watcher = hs.pathwatcher.new(hs.configdir, scheduleReload):start()
end

return M
