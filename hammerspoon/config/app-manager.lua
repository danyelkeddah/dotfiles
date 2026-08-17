local M = {}

local applications = require("apps")

local function toggleApplication(application)
    local frontmost = hs.application.frontmostApplication()
    if frontmost and frontmost:bundleID() == application.bundleId then
        frontmost:hide()
        return
    end

    local opened = hs.application.launchOrFocusByBundleID(application.bundleId)
    if not opened then
        hs.alert.show("Could not open " .. application.name)
    end
end

function M.register(modifiers)
    for _, app in pairs(applications) do
        local application = app
        hs.hotkey.bind(modifiers, application.key, function()
            toggleApplication(application)
        end)
    end
end

return M
