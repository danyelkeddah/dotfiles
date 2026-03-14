hyper = { "cmd", "alt", "ctrl" }
bigHyper = { "shift", "cmd", "alt", "ctrl" }
altCommand = { "alt", "cmd" }
ctrlCommand = { "ctrl", "cmd" }
commandCtrlShift = { "cmd", "ctrl", "shift" }

local appManager = require("app-manager")
local windowManager = require("window-manager")
appManager.register()
windowManager.register()

hs.hotkey.bind(hyper, "R", function()
    hs.reload()
end)

hs.notify.show("Hammerspoon loaded", "", "🚀")
