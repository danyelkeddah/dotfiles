local M = {}

M.register = function()
    -- Right half
    hs.hotkey.bind(altCommand, "Right", function()
        local win = hs.window.focusedWindow()
        local f = win:frame()
        local screen = win:screen()
        local max = screen:frame()

        f.x = max.x + (max.w / 2)
        f.y = max.y
        f.w = max.w / 2
        f.h = max.h
        win:setFrame(f)
    end)

    -- Left Half
    hs.hotkey.bind(altCommand, "Left", function()
        local win = hs.window.focusedWindow()
        local f = win:frame()
        local screen = win:screen()
        local max = screen:frame()

        f.x = max.x
        f.y = max.y
        f.w = max.w / 2
        f.h = max.h
        win:setFrame(f)
    end)

    -- Top half
    hs.hotkey.bind(altCommand, "Up", function()
        local win = hs.window.focusedWindow()
        local f = win:frame()
        local screen = win:screen()
        local max = screen:fullFrame()

        f.x = max.x
        f.y = max.y + (max.y / 2)
        f.w = max.w
        f.h = max.h / 2
        win:setFrame(f)
    end)

    -- Bottom half
    hs.hotkey.bind(altCommand, "Down", function()
        local win = hs.window.focusedWindow()
        local f = win:frame()
        local screen = win:screen()
        local max = screen:frame()

        f.x = max.x
        f.y = max.y + (max.h / 2)
        f.w = max.w
        f.h = max.h / 2
        win:setFrame(f)
    end)

    -- Fullscreen
    hs.hotkey.bind(altCommand, "f", function()
        local win = hs.window.focusedWindow()
        local f = win:frame()
        local screen = win:screen()
        local max = screen:frame()

        f.x = max.x
        f.y = max.y
        f.w = max.w
        f.h = max.h
        win:setFrame(f)
    end)

    -- right top quarter
    hs.hotkey.bind(ctrlCommand, "Right", function()
        local win = hs.window.focusedWindow()
        local f = win:frame()
        local screen = win:screen()
        local max = screen:frame()

        f.x = max.x + (max.w / 2)
        f.y = max.y
        f.w = max.w / 2
        f.h = max.h / 2
        win:setFrame(f)
    end)

    -- Left top quarter
    hs.hotkey.bind(ctrlCommand, "Left", function()
        local win = hs.window.focusedWindow()
        local f = win:frame()
        local screen = win:screen()
        local max = screen:frame()

        f.x = max.x
        f.y = max.y
        f.w = max.w / 2
        f.h = max.h / 2
        win:setFrame(f)
    end)

    -- right bottom quarter
    hs.hotkey.bind(commandCtrlShift, "Right", function()
        local win = hs.window.focusedWindow()
        local f = win:frame()
        local screen = win:screen()
        local max = screen:frame()

        f.x = max.x + (max.w / 2)
        f.y = max.y + (max.h / 2)
        f.w = max.w / 2
        f.h = max.h / 2

        win:setFrame(f)
    end)

    -- left bottom quarter
    hs.hotkey.bind(commandCtrlShift, "Left", function()
        local win = hs.window.focusedWindow()
        local f = win:frame()
        local screen = win:screen()
        local max = screen:frame()

        f.x = max.x
        f.y = max.y + (max.h / 2)
        f.w = max.w / 2
        f.h = max.h / 2

        win:setFrame(f)
    end)
end

return M
