#!/usr/bin/env lua

require 'cairo'

local shape = require("background.settings")

local constant = {
    shape_margin_x = 5,
    shape_margin_y = 5,
    shape_offset = 150,
    rectangle_width = 140,
    rectangle_height = 140,
    line_position_1 = 69,
    line_position_2 = 40
}


-- Math round

function Round(num)
    if num == nil then
        return 0
    else
        return math.floor(tonumber(num+0.5))
    end
end


-- Color conversion

local function hexToRGB(hex)
    hex = hex:gsub("#", "")

    local rHex, gHex, bHex = hex:match("(%x%x)(%x%x)(%x%x)")

    if not rHex then
        return nil, "Invalide hexadécimal format"
    end

    local r = tonumber(rHex, 16) / 255
    local g = tonumber(gHex, 16) / 255
    local b = tonumber(bHex, 16) / 255

    return r, g, b
end


-- Draw rectangle

local function draw_rounded_rectangle(cr, rectangle_position, width, height)
    local margin_y = constant.shape_margin_y + rectangle_position

    -- Rectangle
    cairo_new_sub_path(cr)
    cairo_arc(cr, constant.shape_margin_x + width - shape.radius, margin_y + shape.radius, shape.radius, -math.pi / 2, 0)
    cairo_arc(cr, constant.shape_margin_x + width - shape.radius, margin_y + height - shape.radius, shape.radius, 0, math.pi / 2)
    cairo_arc(cr, constant.shape_margin_x + shape.radius, margin_y + height - shape.radius, shape.radius, math.pi / 2, math.pi)
    cairo_arc(cr, constant.shape_margin_x + shape.radius, margin_y + shape.radius, shape.radius, math.pi, 3 * math.pi / 2)
    cairo_close_path(cr)

    -- Fill
    local r, g, b = hexToRGB(shape.fill_color)
    cairo_set_source_rgba(cr, r, g, b, shape.fill_alpha)
    cairo_fill_preserve(cr)

    -- Border
    r, g, b = hexToRGB(shape.border_color)
    cairo_set_source_rgba(cr, r, g, b, shape.border_alpha)
    cairo_set_line_width(cr, shape.border_width)
    cairo_stroke(cr)
end


-- Draw line

local function draw_line(cr, rectangle_position, line_position, width)

    local position_y = constant.shape_margin_y + rectangle_position + line_position + 0.5
    local x1 = constant.shape_margin_x
    local x2 = constant.shape_margin_x + width
    local pat = cairo_pattern_create_linear(x1, position_y, x2, position_y)

    -- Line
    local r, g, b = hexToRGB(shape.line_color)
    cairo_pattern_add_color_stop_rgba(pat, 0.0, r, g, b, 0.0)
    cairo_pattern_add_color_stop_rgba(pat, 0.5, r, g, b, shape.line_alpha)
    cairo_pattern_add_color_stop_rgba(pat, 1.0, r, g, b, 0.0)

    -- Tracé de la ligne
    cairo_move_to(cr, x1, position_y)
    cairo_line_to(cr, x2, position_y)
    cairo_set_source(cr, pat)
    cairo_set_line_width(cr, shape.line_width)
    cairo_stroke(cr)

    -- Cleanup
    cairo_pattern_destroy(pat)
end


-- Draw one shape (rectangle + line)

local function draw_shape(cr, rectangle_position, rectangle_width, rectangle_height, line_position)
    -- Rectangle
    draw_rounded_rectangle(cr, rectangle_position, rectangle_width, rectangle_height)
    -- Line
    draw_line(cr, rectangle_position, line_position, rectangle_width)
end


-- Draw all shapes

local function draw_shapes(segments)
    if conky_window == nil then return end

    local cs = nil
    local created_locally = false

    if type(conky_surface) == "function" then
        cs = conky_surface()
    end

    if cs == nil then
        if conky_window.display == nil or conky_window.drawable == nil then return end

        cs = cairo_xlib_surface_create(
            conky_window.display,
            conky_window.drawable,
            conky_window.visual,
            conky_window.width,
            conky_window.height
        )
        created_locally = true
    end

    if cs == nil then return end

    local cr = cairo_create(cs)

    -- Backgrounds
    local shape_offset = Round(constant.shape_offset * shape.scaling_factor)

    local rectangle_position = 0
    local rectangle_width = Round(constant.rectangle_width * shape.scaling_factor)
    local rectangle_height = Round(constant.rectangle_height * shape.scaling_factor)

    local line_position_1 = Round(constant.line_position_1 * shape.scaling_factor)
    local line_position_2 = Round(constant.line_position_2 * shape.scaling_factor)

    for i = 1, segments, 1 do
        local line_position = (i == 1) and line_position_1 or line_position_2
        draw_shape(cr, rectangle_position, rectangle_width, rectangle_height, line_position)

        rectangle_position = rectangle_position + shape_offset
    end

    -- Cleanup
    cairo_destroy(cr)
    if created_locally then
        cairo_surface_destroy(cs)
    end
end


-- Conky calls

function conky_draw_background_4_segments()
    draw_shapes(4)
end

function conky_draw_background_5_segments()
    draw_shapes(5)
end


