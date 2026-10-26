local waywall = require("waywall")

local M = {}

M.exec = function()
    waywall.sleep(1000)
    waywall.exec("java -jar /home/kehler/.config/waywall/ninjabrain-bot.jar")
    return true
end

M.timer = function(config, cfg)
    local nb = 0
    config.actions["*-C"] = function()
        if waywall.get_key("F3") then
            waywall.press_key("C")
            waywall.show_floating(true)
            nb = nb + 1
            local nb_cur = nb
            waywall.sleep(1000 * cfg.timer_length)
            if nb_cur == nb and cfg.timer_length ~= 0 then
                waywall.show_floating(false)
            end
        end
        return false
    end
end

return M
