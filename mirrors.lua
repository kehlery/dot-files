local helpers = require("waywall.helpers")
local util = require("util")

local M = {}
local initialized = false
local toggle_tall_pie_impl = nil

function M.toggle_tall_pie()
    if not toggle_tall_pie_impl then
        return false
    end
    return toggle_tall_pie_impl()
end

function M.setup()
    if initialized then
        return
    end
    initialized = true

    local config_dir = (os.getenv("XDG_CONFIG_HOME") or (os.getenv("HOME") .. "/.config")) .. "/waywall"

    -- Oneshot dot
    helpers.res_image(
        config_dir .. "/dot.png",
        {
            dst = { x = 959, y = 539, w = 2, h = 2 },
        },
        320, 16384
    )

    -- Eye magnifier
    helpers.res_mirror(
        {
            src = { x = 130, y = 7902, w = 60, h = 580 },
            dst = { x = 0, y = 315, w = 800, h = 450 },
        },
        320, 16384
    )
    helpers.res_image(
        config_dir .. "/overlay.png",
        {
            dst = { x = 0, y = 315, w = 800, h = 450 },
        },
        320, 16384
    )

    -- Tall pie
    toggle_tall_pie_impl = util.ref_res_mirror(
        {
            src = { x = 0, y = 15980, w = 320, h = 260 },
            dst = { x = 800, y = 586, w = 320, h = 260 },
        },
        320, 16384
    )

    -- Tall hotbar
    helpers.res_mirror(
        {
            src = { x = 50, y = 16344, w = 220, h = 40 },
            dst = { x = 520, y = 920, w = 880, h = 160 },
        },
        320, 16384
    )

    -- Thin and tall C counts
    helpers.res_mirror(
        {
            src = { x = 0, y = 28, w = 49, h = 9 },
            dst = { x = 1120, y = 400, w = 196, h = 36 },
            depth = 1,
        },
        320, 900
    )
    helpers.res_mirror(
        {
            src = { x = 0, y = 28, w = 49, h = 9 },
            dst = { x = 1120, y = 400, w = 196, h = 36 },
            depth = 1,
        },
        320, 16384
    )

    -- Thin and tall entity counts
    helpers.res_mirror(
        {
            src = { x = 0, y = 36, w = 49, h = 9 },
            dst = { x = 1120, y = 440, w = 196, h = 36 },
            depth = 1,
        },
        320, 900
    )
    helpers.res_mirror(
        {
            src = { x = 0, y = 36, w = 49, h = 9 },
            dst = { x = 1120, y = 440, w = 196, h = 36 },
            depth = 1,
        },
        320, 16384
    )

    -- Thin and tall pie numbers
    helpers.res_mirror(
        {
            src = { x = 228, y = 680, w = 32, h = 24 },
            dst = { x = 1120, y = 600, w = 196, h = 144 },
        },
        320, 900
    )
    helpers.res_mirror(
        {
            src = { x = 228, y = 16164, w = 32, h = 24 },
            dst = { x = 1120, y = 600, w = 196, h = 144 },
        },
        320, 16384
    )

    -- Tall and thin subtitles
    helpers.res_mirror(
        {
            src = { x = 195, y = 16279, w = 124, h = 80 },
            dst = { x = 1420, y = 660, w = 496, h = 320 },
        },
        320, 16384
    )
    helpers.res_mirror(
        {
            src = { x = 195, y = 795, w = 124, h = 80 },
            dst = { x = 1420, y = 660, w = 496, h = 320 },
        },
        320, 900
    )

    -- Thin and tall chat
    helpers.res_mirror(
        {
            src = { x = 0, y = 816, w = 160, h = 44 },
            dst = { x = 0, y = 744, w = 640, h = 176 },
        },
        320, 900
    )
    helpers.res_mirror(
        {
            src = { x = 0, y = 16300, w = 160, h = 44 },
            dst = { x = 0, y = 744, w = 640, h = 176 },
        },
        320, 16384
    )

    -- Thin and tall pie entity counts
    helpers.res_mirror(
        {
            src = { x = 14, y = 38, w = 5, h = 7 },
            dst = { x = 930, y = 782, w = 40, h = 56 },
            depth = 1,
        },
        320, 900
    )
    helpers.res_mirror(
        {
            src = { x = 14, y = 38, w = 5, h = 7 },
            dst = { x = 930, y = 782, w = 40, h = 56 },
            depth = 1,
        },
        320, 16384
    )
end

return M
