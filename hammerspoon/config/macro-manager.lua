local M = {}

local modalTimeout = 3
local timeoutTimer

local macros = {
    s = function()
        hs.eventtap.keyStroke({ "cmd", "shift" }, "4")
    end,
    e = function()
        hs.eventtap.keyStroke({ "cmd", "ctrl" }, "space")
    end,
    a = function()
        hs.eventtap.keyStroke({ "cmd" }, "`")
    end,
    l = function()
        hs.caffeinate.lockScreen()
    end,
}

local function stopTimeout()
    if timeoutTimer then
        timeoutTimer:stop()
        timeoutTimer = nil
    end
end

function M.register(modifiers)
    local modal = hs.hotkey.modal.new(modifiers, "m")
    M.modal = modal

    function modal:entered()
        stopTimeout()
        timeoutTimer = hs.timer.doAfter(modalTimeout, function()
            modal:exit()
        end)
        hs.alert.show("Macro mode", nil, nil, 0.5)
    end

    function modal:exited()
        stopTimeout()
    end

    for key, action in pairs(macros) do
        local macro = action
        modal:bind({}, key, nil, function()
            modal:exit()
            macro()
        end)
    end

    modal:bind({}, "escape", nil, function()
        modal:exit()
    end)
end

return M
