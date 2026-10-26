local waywall = require("waywall")
local helpers = require("waywall.helpers")

local M = {}

function M.ref_res_mirror(options, width, height)
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

function M.make_res(width, height, sensitivity, require_unpaused, ignore_f3, keep_resolution_in_menus)
    local toggle = helpers.toggle_res(width, height, sensitivity)

    return function()
        if waywall.get_key("F3") and not ignore_f3 then
            return false
        end

        local state = waywall.state()
        local active_width, active_height = waywall.active_res()
        local allowed = not require_unpaused
            or (state.screen == "inworld" and state.inworld == "unpaused")

        if allowed then
            toggle()
            return true
        end

        if (active_width ~= 0 or active_height ~= 0) and not keep_resolution_in_menus then
            waywall.set_resolution(0, 0)
            waywall.set_sensitivity(0)
            return true
        end

        return false
    end
end

return M
