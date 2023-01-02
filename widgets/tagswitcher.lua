
local wibox = require 'wibox'
local awful = require 'awful'
local gears = require 'gears'
local naughty = require 'naughty'
local test = require 'modules.bling.widget.tag_preview'
local cairo = require 'lgi'.cairo
local helpers = require 'modules.bling.helpers'


-- local function draw_widget(
--     t,
--     tag_preview_image,
--     scale,
--     screen_radius,
--     client_radius,
--     client_opacity,
--     client_bg,
--     client_border_color,
--     client_border_width,
--     widget_bg,
--     widget_border_color,
--     widget_border_width,
--     geo,
--     margin,
--     background_image
-- )
--     local client_list = wibox.layout.manual()
--     client_list.forced_height = geo.height
--     client_list.forced_width = geo.width
--     local tag_screen = t.screen
--     for i, c in ipairs(t:clients()) do
--         if not c.hidden and not c.minimized then


--             local img_box = wibox.widget ({
--                 resize = true,
--                 forced_height = 100 * scale,
--                 forced_width = 100 * scale,
--                 widget = wibox.widget.imagebox,
--             })

-- 			-- If fails to set image, fallback to a awesome icon
-- 			if not pcall(function() img_box.image = gears.surface.load(c.icon) end) then
-- 				img_box.image = beautiful.theme_assets.awesome_icon (24, "#222222", "#fafafa")
-- 			end

--             if tag_preview_image then
--                 if c.prev_content or t.selected then
--                     local content
--                     if t.selected then
--                         content = gears.surface(c.content)
--                     else
--                         content = gears.surface(c.prev_content)
--                     end
--                     local cr = cairo.Context(content)
--                     local x, y, w, h = cr:clip_extents()
--                     local img = cairo.ImageSurface.create(
--                         cairo.Format.ARGB32,
--                         w - x,
--                         h - y
--                     )
--                     cr = cairo.Context(img)
--                     cr:set_source_surface(content, 0, 0)
--                     cr.operator = cairo.Operator.SOURCE
--                     cr:paint()

--                     img_box = wibox.widget({
--                         image = gears.surface.load(img),
--                         resize = true,
--                         opacity = client_opacity,
--                         forced_height = math.floor(c.height * scale),
--                         forced_width = math.floor(c.width * scale),
--                         widget = wibox.widget.imagebox,
--                     })
--                 end
--             end

--             local client_box = wibox.widget({
--                 {
--                     nil,
--                     {
--                         nil,
--                         img_box,
--                         nil,
--                         expand = "outside",
--                         layout = wibox.layout.align.horizontal,
--                     },
--                     nil,
--                     expand = "outside",
--                     widget = wibox.layout.align.vertical,
--                 },
--                 forced_height = math.floor(c.height * scale),
--                 forced_width = math.floor(c.width * scale),
--                 bg = client_bg,
--                 shape_border_color = client_border_color,
--                 shape_border_width = client_border_width,
--                 shape = helpers.shape.rrect(client_radius),
--                 widget = wibox.container.background,
--             })

--             client_box.point = {
--                 x = math.floor((c.x - geo.x) * scale),
--                 y = math.floor((c.y - geo.y) * scale),
--             }

--             client_list:add(client_box)
--         end
--     end
    
    
--     return wibox.widget {
--         {
--             {
--                 {
--                     {
--                         {
--                             client_list,
--                             forced_height = geo.height,
--                             forced_width = geo.width,
--                             widget = wibox.container.place,
--                         },
--                         layout = wibox.layout.align.horizontal,
--                     },
--                     layout = wibox.layout.align.vertical,
--                 },
--                 margins = margin,
--                 widget = wibox.container.margin,
--             },
--             layout = wibox.layout.stack
--         },
--         shape = helpers.shape.rrect(screen_radius),
--         widget = wibox.container.background,
--     }
-- end
local function init(s) 
    local switcher= wibox{visible = false, ontop = true,  height = s.geometry.height - 53, width = s.geometry.width, bg = "#292c3c"}
    switcher:connect_signal("self::toggle", function()
        
        awful.placement.top(switcher)
        
    
        switcher.visible = not switcher.visible
        s.tasklist.ontop = not s.tasklist.ontop
        if switcher.visible then
            local grabber 
            grabber = awful.keygrabber.run(function(mod, key, event)
                if key == 'Escape' then
                    switcher:emit_signal("self::toggle")
                    awful.keygrabber.stop(grabber) 
                end
                
                

                
            end)
        end
    end)
    
    local t = awful.screen.focused().selected_tag
    
    local geo = t.screen:get_bounding_geometry({
            honor_padding = false,
            honor_workarea = false,
    })

    switcher:setup {
        layout = wibox.layout.stack,
        {
            widget = wibox.container.place, 
            halign = 'center',
            valign = 'center',
            forced_height = 150,
            forced_width = 250, 
            {
                widget = wibox.container.background, 
                bg = "#fff555",
                shape = function(cr, w, h)
                    gears.shape.rounded_rect(cr, w, h, 16)
                end, 
                forced_height = 650, 
                forced_width = 1350, 
                id = "test", 
                
            
            }
        }
    }
    
    return switcher 
    
end

return {
    init = init 
}