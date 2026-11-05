local waywall = require("waywall")
local keyboard = require("keyboard")

local M = {}

local function keymapper_send(state)
    if state.screen == "generating" then
        waywall.exec("keymapperctl --output K")
    end
    if state.screen == "inworld" and state.inworld ~= "paused" then
        waywall.exec("keymapperctl --output F24")
    else
    waywall.exec("keymapperctl --output F8")
    end
end

M.state_checker = function()
	local prev_state = waywall.state()

	return function()
		local new_state = waywall.state()

		if
			new_state.screen == "inworld"
			and new_state.screen == prev_state.screen
			and new_state.inworld == prev_state.inworld
		then
			return
		end

        keyboard.change_keymap(new_state)
        keymapper_send(new_state)

		prev_state = new_state
	end
end

return M
