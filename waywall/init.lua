local waywall = require("waywall")
local helpers = require("waywall.helpers") 

local keyboard = require("keyboard")
local keymapper = require("keymapper")
local mirrors = require("mirrors")
local ninb = require("ninb")
local util = require("util")

local config_dir = (os.getenv("XDG_CONFIG_HOME") or (os.getenv("HOME") .. "/.config")) .. "/waywall"

-- Explicitly run modules
keyboard.setup()
mirrors.setup()
keymapper.setup(keyboard, config_dir)
ninb.setup(config_dir)

local config = {
    input = {
        layout = "us",
        sensitivity = 5.32,
        confine_pointer = false,
    },
    theme = {
        background = "#000000",
        ninb_anchor = {
            position = "topright",
            y = 102,
        },
        ninb_opacity = 1.0,
    },
    experimental = {
        jit = false,
        tearing = true,
    },
}

local resolutions = {
    --                   width  height  sens   require_unpaused  ignore_f3  keep_resolution_in_menus
    thin = util.make_res(320,   900,    0,     true,             true,      false),
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

    -- Ninjabrain Bot
    ["*-K"] = function()
        waywall.show_floating(false)
        return true
    end,
}

-- Need to run this before crafting-mode guarding cause it calls config.actions
ninb.timer(config, {
    timer_length = 10,
})

-- Factory for wrapper
local function guarded_action(action)
    return function()
        if not keyboard.do_keybinds() then
            return false
        end
        return action()
    end
end

-- Disable stuff while chatting
for key, action in pairs(config.actions) do
    config.actions[key] = guarded_action(action)
end

-- Always available, including while chatting
config.actions["*-F11"] = keyboard.toggle_layout

return config
