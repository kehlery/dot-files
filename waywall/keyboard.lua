local waywall = require("waywall")

local chatting_text = nil
local is_crafting = true
local active_remap = "unpaused"

local M = {}

local keymap_chatting = {layout = "us", options = "caps:none"}
local keymap_crafting = {layout = "mc", rules = "mc", options = "caps:none"}

local remaps = {
    always = {
        ["MMB"]      = "Backspace",  ["Backspace"]  = "F22",
        ["MB5"]      = "Home",       ["Home"]       = "F22",
        ["LeftMeta"] = "RightShift", ["RightShift"] = "F22",
        ["B"]        = "RightCtrl",  ["RightCtrl"]  = "F22",
        ["Z"]        = "0",          ["0"]          = "F22",

        ["R"]        = "B",
        ["A"]        = "F21",
        ["D"]        = "F20",
        ["T"]        = "F19",
        ["CapsLock"] = "F18",
    },
    unpaused = {
        ["WWW"] = "F3",
        ["F3"]  = "F22",
    },
    menu = {
        ["WWW"] = "F17",
    },
}

-- Share the always-on mappings between the two crafting remap sets.
for key, value in pairs(remaps.always) do
    remaps.unpaused[key] = value
    remaps.menu[key] = value
end

-- During chatting, return no remaps even if another part of the config
-- asks for the menu/unpaused set and passes the result to waywall.set_remaps.
local function selected_remaps()
    if not is_crafting then
        return {}
    end
    return remaps[active_remap]
end

-- Report whether crafting mode is active; init.lua uses this to guard actions.
M.do_keybinds = function()
    return is_crafting
end

-- Preserve the original API and remember the most recently selected set.
M.unpaused = function()
    active_remap = "unpaused"
    return selected_remaps()
end

M.menu = function()
    active_remap = "menu"
    return selected_remaps()
end

M.toggle_layout = function()
    if is_crafting then
        -- Enter chatting mode and clear every active remap.
        is_crafting = false
        waywall.set_keymap(keymap_chatting)
        waywall.set_remaps({})

        if not chatting_text then
            chatting_text = waywall.text("layout", {
                x = 10, y = 960, color = "#ee4444", size = 5,
            })
        end
    else
        -- Return to crafting with the last selected remap set.
        is_crafting = true
        waywall.set_keymap(keymap_crafting)
        waywall.set_remaps(remaps[active_remap])

        if chatting_text then
            chatting_text:close()
            chatting_text = nil
        end
    end
end

waywall.listen("load", function()
    waywall.set_keymap(keymap_crafting)
    waywall.set_remaps(remaps[active_remap])
end)

return M
