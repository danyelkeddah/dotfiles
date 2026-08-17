local M = {}

-- Number of recently focused applications included in the cycle.
local recentApplicationLimit = 2
local cycleResetDelay = 1

local recentWindows = {}
local isCycling = false
local cycleResetTimer

local function applicationForWindow(window)
    if not window then
        return nil
    end

    local ok, application = pcall(function()
        return window:application()
    end)
    return ok and application or nil
end

local function rememberWindow(window)
    if isCycling then
        return
    end

    local application = applicationForWindow(window)
    local bundleId = application and application:bundleID()
    if not bundleId then
        return
    end

    for index = #recentWindows, 1, -1 do
        local recentApplication = applicationForWindow(recentWindows[index])
        if not recentApplication or recentApplication:bundleID() == bundleId then
            table.remove(recentWindows, index)
        end
    end

    table.insert(recentWindows, 1, window)
    while #recentWindows > recentApplicationLimit do
        table.remove(recentWindows)
    end
end

local function finishCycleLater()
    if cycleResetTimer then
        cycleResetTimer:stop()
    end

    cycleResetTimer = hs.timer.doAfter(cycleResetDelay, function()
        isCycling = false
        rememberWindow(hs.window.focusedWindow())
    end)
end

local function cycleRecentApplications()
    for index = #recentWindows, 1, -1 do
        if not applicationForWindow(recentWindows[index]) then
            table.remove(recentWindows, index)
        end
    end

    if #recentWindows < 2 then
        return
    end

    local focused = hs.window.focusedWindow()
    local focusedId = focused and focused:id()
    local currentIndex = 0

    for index, window in ipairs(recentWindows) do
        if focusedId and window:id() == focusedId then
            currentIndex = index
            break
        end
    end

    local nextIndex = (currentIndex % #recentWindows) + 1
    local targetWindow = recentWindows[nextIndex]
    local targetApplication = applicationForWindow(targetWindow)
    if not targetApplication then
        return
    end

    isCycling = true
    targetApplication:activate()
    targetWindow:focus()
    finishCycleLater()
end

function M.register(modifiers)
    rememberWindow(hs.window.focusedWindow())
    M.windowFilter = hs.window.filter.default:subscribe(hs.window.filter.windowFocused, rememberWindow)
    hs.hotkey.bind(modifiers, "tab", cycleRecentApplications)
end

return M
