local meh = { "ctrl", "alt", "shift" }

-- Start this first so later configuration errors do not disable file watching.
require("config-reloader").start()

require("app-manager").register(meh)
require("app-switcher").register(meh)
require("macro-manager").register(meh)
require("window-manager").register(meh)
