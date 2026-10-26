local waywall = require("waywall")

local M = {}

local chatting_text = nil
local is_crafting = true
local active_remap = "unpaused"
local initialized = false

local keymap_chatting = { layout = "us", options = "caps:none" }
local keymap_crafting = { layout = "mc", rules = "mc", options = "caps:none" }

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

-- Add the common mappings to both crafting states
for key, value in pairs(remaps.always) do
    remaps.unpaused[key] = value
    remaps.menu[key] = value
end

local function selected_remaps()
    if not is_crafting then
        return {}
    end
    return remaps[active_remap]
end

-- State manager version for changing
function M.apply_for_state(state)
    if state.screen == "inworld" and state.inworld == "menu" then
        active_remap = "menu"
    else
        active_remap = "unpaused"
    end

    waywall.set_remaps(selected_remaps())
end

function M.do_keybinds()
    return is_crafting
end

-- Direct caller for changing
function M.unpaused()
    active_remap = "unpaused"
    return selected_remaps()
end

function M.menu()
    active_remap = "menu"
    return selected_remaps()
end

function M.toggle_layout()
    if is_crafting then
        is_crafting = false
        waywall.set_keymap(keymap_chatting)
        waywall.set_remaps({})

        if not chatting_text then
            chatting_text = waywall.text("layout", {
                x = 10,
                y = 960,
                color = "#ee4444",
                size = 5,
            })
        end
    else
        is_crafting = true
        waywall.set_keymap(keymap_crafting)
        waywall.set_remaps(remaps[active_remap])

        if chatting_text then
            chatting_text:close()
            chatting_text = nil
        end
    end
    return true
end

function M.setup()
    if initialized then
        return
    end
    initialized = true

    waywall.listen("load", function()
        waywall.set_keymap(keymap_crafting)
        M.apply_for_state(waywall.state())
    end)
end

return M
