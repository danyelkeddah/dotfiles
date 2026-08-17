local M = {}

local frameTolerance = 4
local cycleSizes = { 1 / 3, 0.5, 2 / 3, 3 / 4 }
local centerSizes = { 0.8, 0.9, 0.95 }

local function focusedWindow()
    return hs.window.focusedWindow()
end

local function frameForDirection(screen, direction, size)
    if direction == "left" then
        return { x = screen.x, y = screen.y, w = screen.w * size, h = screen.h }
    end
    if direction == "right" then
        return {
            x = screen.x + (screen.w * (1 - size)),
            y = screen.y,
            w = screen.w * size,
            h = screen.h,
        }
    end
    if direction == "top" then
        return { x = screen.x, y = screen.y, w = screen.w, h = screen.h * size }
    end

    return {
        x = screen.x,
        y = screen.y + (screen.h * (1 - size)),
        w = screen.w,
        h = screen.h * size,
    }
end

local function framesMatch(current, target)
    return math.abs(current.x - target.x) <= frameTolerance
        and math.abs(current.y - target.y) <= frameTolerance
        and math.abs(current.w - target.w) <= frameTolerance
        and math.abs(current.h - target.h) <= frameTolerance
end

local function cycleDirection(direction)
    local window = focusedWindow()
    if not window then
        return
    end

    local screen = window:screen():frame()
    local current = window:frame()
    local nextIndex = 1

    for index, size in ipairs(cycleSizes) do
        if framesMatch(current, frameForDirection(screen, direction, size)) then
            nextIndex = (index % #cycleSizes) + 1
            break
        end
    end

    window:setFrame(frameForDirection(screen, direction, cycleSizes[nextIndex]))
end

local function maximize()
    local window = focusedWindow()
    if window then
        window:setFrame(window:screen():frame())
    end
end

local function centeredFrame(screen, size)
    local margin = (1 - size) / 2
    return {
        x = screen.x + (screen.w * margin),
        y = screen.y + (screen.h * margin),
        w = screen.w * size,
        h = screen.h * size,
    }
end

local function cycleCenter()
    local window = focusedWindow()
    if not window then
        return
    end

    local screen = window:screen():frame()
    local current = window:frame()
    local nextIndex = 1

    for index, size in ipairs(centerSizes) do
        if framesMatch(current, centeredFrame(screen, size)) then
            nextIndex = (index % #centerSizes) + 1
            break
        end
    end

    window:setFrame(centeredFrame(screen, centerSizes[nextIndex]))
end

local function moveToScreen(direction)
    local window = focusedWindow()
    if not window then
        return
    end

    local screen = window:screen()
    local target = direction == "next" and screen:next() or screen:previous()
    if target and target:id() ~= screen:id() then
        window:moveToScreen(target)
    end
end

local function focusWindow(direction)
    local window = focusedWindow()
    if not window then
        return
    end

    if direction == "left" then
        window:focusWindowWest(nil, true)
    elseif direction == "right" then
        window:focusWindowEast(nil, true)
    elseif direction == "up" then
        window:focusWindowNorth(nil, true)
    else
        window:focusWindowSouth(nil, true)
    end
end

function M.register(modifiers)
    hs.window.animationDuration = 0

    local directions = {
        h = "left",
        j = "bottom",
        k = "top",
        l = "right",
    }

    for key, direction in pairs(directions) do
        local targetDirection = direction
        hs.hotkey.bind(modifiers, key, function()
            cycleDirection(targetDirection)
        end)
    end

    local focusDirections = {
        left = "left",
        down = "down",
        up = "up",
        right = "right",
    }

    for key, direction in pairs(focusDirections) do
        local targetDirection = direction
        hs.hotkey.bind(modifiers, key, function()
            focusWindow(targetDirection)
        end)
    end

    hs.hotkey.bind(modifiers, "f", maximize)
    hs.hotkey.bind(modifiers, "c", cycleCenter)
    hs.hotkey.bind(modifiers, "[", function()
        moveToScreen("previous")
    end)
    hs.hotkey.bind(modifiers, "]", function()
        moveToScreen("next")
    end)
end

return M
