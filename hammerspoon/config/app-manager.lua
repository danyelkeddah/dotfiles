local applications = {
    WezTerm = {
        id = "com.github.wez.wezterm",
        key = "t",
    },
    Music = {
        id = "com.apple.Music",
        key = "m",
    },
    Slack = {
        id = "com.tinyspeck.slackmacgap",
        key = "s",
    },
    Discord = {
        id = "com.hnc.Discord",
        key = "d",
    },
    Obsidian = {
        id = "md.obsidian",
        key = "n",
    },
    Finder = {
        id = "com.apple.finder",
        key = "f",
    },
    Chrome = {
        id = "com.google.Chrome",
        key = "b",
    },
}

local M = {}

M.register = function()
    for _, value in pairs(applications) do
        hs.hotkey.bind(bigHyper, value.key, function()
            hs.application.launchOrFocusByBundleID(value.id)
        end)
    end
end

return M
