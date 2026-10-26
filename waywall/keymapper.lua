local waywall = require("waywall")

local M = {}
local initialized = false
local last_state_signature = nil

local function command_succeeded(command)
    local status, _, code = os.execute(command)
    if type(status) == "number" then
        return status == 0
    end
    if type(status) == "boolean" then
        return status and (code == nil or code == 0)
    end
    return false
end

local function keymapper_is_running()
    return command_succeeded('pgrep -u "$(id -u)" -x keymapper >/dev/null 2>&1')
end

-- Fixing weird keymapper interactions
local function desired_output(state)
    if state.screen == "generating" then
        return "K"
    end
    if state.screen == "inworld" and state.inworld ~= "paused" then
        return "F24"
    end
    return "F23"
end

local function apply_state(keyboard, state, force_output)
    local signature = tostring(state.screen) .. ":" .. tostring(state.inworld)

    if force_output or signature ~= last_state_signature then
        waywall.exec("keymapperctl --output " .. desired_output(state))
        last_state_signature = signature
    end

    keyboard.apply_for_state(state)
end

function M.setup(keyboard, config_dir)
    if initialized then
        return
    end
    initialized = true

    local keymapper_config = config_dir .. "/km-unpaused.conf"

    waywall.listen("state", function()
        apply_state(keyboard, waywall.state(), false)
    end)

    waywall.listen("load", function()
        if keymapper_is_running() then
            waywall.exec("keymapperctl --set-config " .. keymapper_config)
        else
            waywall.exec("keymapper -c " .. keymapper_config)
        end

        waywall.sleep(500)
        last_state_signature = nil
        apply_state(keyboard, waywall.state(), true)
    end)
end

return M
