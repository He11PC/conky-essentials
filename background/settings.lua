--[[

Background settings

---

scaling_factor = percentage / 100 (0.8 = 80%, 1 = 100%, 1.2 = 120%)

radius = rounded corners radius

color = hexadecimal value with or without the leading #

alpha = opacity, between 0 (100% transparent) and 1 (100% opaque)

width = in pixels

--]]

local shape = {
    scaling_factor = 1,
    radius = 6,
    fill_color = "#000000",
    fill_alpha = 0.8,
    border_width = 1,
    border_color = "#4682B4",
    border_alpha = 1.0,
    line_width = 1,
    line_color = "#4682B4",
    line_alpha = 1.0
}

return shape
