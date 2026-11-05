local waywall = require("waywall")
local helpers = require("waywall.helpers")

local keyboard = require("keyboard")
local util = require("util")
local state = require("state")
local mirrors = require("mirrors")

local ninb_is_running = false
local keymapper_is_running = false

local config = {
    input = {
        layout = "mc",
        rules = "mc",
        options = "caps:none",
        sensitivity = 5.32,
        confine_pointer = false,
    },
    theme = {
        background = "#000000",
        ninb_anchor = {
            position = "topright",
        },
        ninb_opacity = 0.7,
    },
    experimental = {
        jit = false,
        tearing = true,
    },
}

local resolutions = {
    --                   width  height  sens   require_unpaused  ignore_f3  keep_resolution_in_menus
    thin = util.make_res(320,   900,    0,     true,             false,     false),
    eye  = util.make_res(320,   16384,  0.05,  false,            false,     false),
    tall = util.make_res(320,   16384,  0,     true,             false,     false),
    wide = util.make_res(1880,  320,    0,     true,             false,     true),
}

config.actions = {
    -- Resolutions
    ["*-Alt_L"]       = resolutions.thin,
    ["*-Shift-Alt_L"] = resolutions.tall,
    ["*-H"]           = resolutions.eye,
    ["*-MMB"]         = resolutions.wide,

    -- Ninjabrain Bot Reset
    ["*-K"] = function()
        waywall.show_floating(false)
        return false
    end,
    -- Ninjabrain Bot Show on F3+C
    ["*-C"] = function()
        if waywall.get_key("F3") then
            waywall.show_floating(true)
        end
    return false
    end,
    -- Ninjabrain Bot Toggle
    ["*-5"] = helpers.toggle_floating,

}

for key, func in pairs(config.actions) do
    config.actions[key] = function()
        return keyboard.do_keybinds() and func() or false
    end
end

config.actions["*-F11"] = keyboard.toggle_layout

-- Startup
waywall.listen("load", function()
	waywall.sleep(10000)
	waywall.listen("state", state.state_checker())
    if not ninb_is_running then
        waywall.exec("java -jar /home/kehler/.config/waywall/ninjabrain-bot.jar")
        ninb_is_running = true
    end
    if not keymapper_is_running then
        waywall.exec("keymapper")
        keymapper_is_running = true
    end

end)

return config
