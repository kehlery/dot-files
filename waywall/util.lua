local waywall = require("waywall")
local helpers = require("waywall.helpers")

local M = {}

M.ref_res_mirror = function(options, width, height)
    local mirror = nil

    local function enable()
        if mirror then
            return
        end

        mirror = waywall.mirror(options)
    end

    local function disable()
        if not mirror then
            return
        end

        mirror:close()
        mirror = nil
    end

    waywall.listen("resolution", function()
        local active_width, active_height = waywall.active_res()

        if active_width == width and active_height == height then
            enable()
        else
            disable()
        end
    end)

    return function()
        local active_width, active_height = waywall.active_res()

        if active_width == width and active_height == height then
            if mirror then
                disable()
            else
                enable()
            end
        end
    end
end

M.make_res = function(width, height, sens, ingame, ignore_f3, menu_disable)
    local toggle = helpers.toggle_res(width, height, sens)

    return function()
        if waywall.get_key("F3") and not ignore_f3 then
            return false
        end

        local state = waywall.state()
        local aw, ah = waywall.active_res()

        local ok = (not ingame) or (state.screen == "inworld" and state.inworld == "unpaused")
        if ok then
            toggle()
            return true
        else
            if aw ~= 0 and not menu_disable then
                waywall.set_resolution(0, 0)
                waywall.set_sensitivity(0)
                return true
            end

            return false
        end
    end
end

return M
