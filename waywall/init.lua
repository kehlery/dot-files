local waywall = require("waywall")
local helpers = require("waywall.helpers")

local keyboard = require("keyboard")
local mirrors = require("mirrors")
local ninb = require("ninb")
local util = require("util")

waywall.listen("load", function()
    waywall.exec("keymapper -c /home/kehler/.config/waywall/km-unpaused.conf")
    waywall.sleep(10000)
    waywall.exec("java -jar /home/kehler/.config/waywall/ninjabrain-bot.jar")
end)


waywall.listen("state", function()
    local state = waywall.state()
    if state.screen == "inworld" and state.inworld ~= "paused" then
        waywall.exec("keymapperctl --output F24")
    else
        waywall.exec("keymapperctl --output F23")
    end
end)


waywall.listen("state", function()
    local state = waywall.state()
    if state.screen == "inworld" and state.inworld == "menu" then
        waywall.set_remaps(keyboard.menu())
    else
        waywall.set_remaps(keyboard.unpaused())
    end
end)

waywall.listen("state", function()
    local state = waywall.state()
    if state.screen == "generating" then
        waywall.exec("keymapperctl --output K")
    else
        return
    end
end)

local config = {
    input = {
        layout = "us",
        -- repeat_rate = 50,
        -- repeat_delay = 200,

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
        jit = true,
        tearing = true,
    }
}

local resolutions = { --            width    height  sens    ingame  blockf3    menu_disable
    thin            = util.make_res(320,     900,    0,      true,   true,      false),
    eye             = util.make_res(320,     16384,  0.05,    false,  false,     false),
    tall            = util.make_res(320,     16384,  0,      true,   false,     false),
    wide            = util.make_res(1880,    320,    0,      true,   false,     true),
}

config.actions = {
    -- Resolutions
    ["*-Alt_L"]         = resolutions.thin,
    ["*-Shift-Alt_L"]   = resolutions.tall,
    ["*-H"]             = resolutions.eye,
    ["*-MMB"]           = resolutions.wide,

    -- Ninjabrain Bot
    ["*-K"]             = function()
                            waywall.show_floating(false)
                          end,

}

for key, func in pairs(config.actions) do
    config.actions[key] = function()
        return keyboard.do_keybinds() and func() or false
    end
end

config.actions["*-F11"] = keyboard.toggle_layout

ninb.timer(config, {
        timer_length = 10
    })

return config
