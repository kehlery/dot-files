local waywall = require("waywall")

local M = {}
local initialized = false

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

local function jar_is_running()
    return command_succeeded('pgrep -u "$(id -u)" -f \'[n]injabrain-bot[.]jar\' >/dev/null 2>&1')
end

local function launch_if_needed(delay_ms, config_dir)
    if jar_is_running() then
        return true
    end

    if delay_ms and delay_ms > 0 then
        waywall.sleep(delay_ms)
    end

    -- In case duplicate happens during delay
    if jar_is_running() then
        return true
    end

    waywall.exec("java -jar " .. config_dir .. "/ninjabrain-bot.jar")
    return true
end

-- For calling more than once
function M.exec()
    local config_dir = (os.getenv("XDG_CONFIG_HOME") or (os.getenv("HOME") .. "/.config")) .. "/waywall"
    return launch_if_needed(1000, config_dir)
end

function M.setup(config_dir)
    if initialized then
        return
    end
    initialized = true

    waywall.listen("load", function()
        launch_if_needed(10000, config_dir)
    end)
end

function M.timer(config, cfg)
    local timer_generation = 0

    config.actions["*-C"] = function()
        if waywall.get_key("F3") then
            waywall.press_key("C")
            waywall.show_floating(true)
            timer_generation = timer_generation + 1
            local this_generation = timer_generation
            waywall.sleep(1000 * cfg.timer_length)
            if this_generation == timer_generation and cfg.timer_length ~= 0 then
                waywall.show_floating(false)
            end
        end
        return false
    end
end

return M
