local _M = {}
local awful = require 'awful'
local gears = require 'gears'
local beautiful = require 'beautiful' 
local wibox = require 'wibox'
local os = require 'os'
local naughty = require 'naughty'
local rubato = require 'rubato'
function wibox_shape(cr, w, h)
    gears.shape.rounded_rect(cr,w,h,15)
    
end 
local pinned_apps = {} 
local bling_icon_helper = require("modules.bling.helpers.icon_theme")
local icon_theme = bling_icon_helper("Colloid-pink-dark", 48)
local excluded_apps = {"starterm", "clock"}
function create_app_widget(client)
    app_widget = wibox.widget {
        widget = wibox.widget.imagebox,
         
        image = icon_theme:get_client_icon_path(client) 

        }
    
    return app_widget
    
end



function _M.return_dock(sc)
    local pinned_apps = {
        {
            class = "firefox", 
            start_command = "firefox", 
            icon = "/usr/share/icons/Colloid-pink-dark/apps/scalable/firefox.png"
        }
    }
    
    local dock = wibox{type = "dock", bg = beautiful.dock_color, opacity=1, visible = false, height = 100, width = 1,x = 750, y = 1090, ontop = true, screen=sc, shape=wibox_shape }
    local dock_detect = wibox{type = "dock", bg = beautiful.dock_color, opacity=0, visible = true, height = 100, width = 420,x = 750, y = 990, ontop = true, screen=sc, shape=wibox_shape, passthrough = true }
    dock_disabled = true 
    dock:connect_signal("self::switch", function()
        if dock_disabled then
            dock_disabled = false 
        else 
            dock_disabled = true 
        end
        
    end)

    slide_up = rubato.timed{
        pos        = 1500,
        duration   = 0.65,
        intro      = 0.3,
        outro      = 0.35,
        easing     = rubato.quadratic,
        subscribed = function(pos, target)
            
            if pos < 1 then
                return 
            end
            dock.y = pos 
            
            
        end
    }
    slide_up.target = 1090

    dock_locked = false 

    pp = awful.menu{
        items = {
        {'Toggle Dock', function()
            naughty.notify({text = "e "})
            
        end},
        {'Lock/Unlock Dock', function()
            naughty.notify({text = "e  "})
            
        end}
    }
    }
    
   
    dock_detect:connect_signal("mouse::enter", function()
        if dock_disabled then
            return 
        end
        slide_up.target = 990
        
        dock_detect.visible = false
        
    end)
    dock:connect_signal("mouse::leave", function()
        if dock_locked then
            
            return 
        end
    
            slide_up.target = 1600
            dock_detect.visible = true 
    end)
    dock:connect_signal("self::lock", function()
        if dock_locked then
            dock_locked = false 
        else 
            dock_locked = true 
        end
        
    end)
    dock:buttons {
        awful.button({}, 3, function()
            -- pp:toggle()
        end)
    }
    dock_layout = wibox.layout.fixed.horizontal{
        spacing = 3
    }
    
    old_width = 0
    old_x = 750
    dock_exclude = {"starterm", "clock"}
    pinned_cache = {}
    -- for k, v in pairs(pinned_apps) do
        
        
    -- end
    client.connect_signal("manage", function(c)
        
        for i, v in ipairs(dock_exclude) do
            if v == c.class then
                
                return 
            end
            
            
        end

        for k, v in pairs(pinned_cache) do
            if k == c.class then
               
                dock_layout:remove_widgets(v)
                old_width = old_width - 95 
                dock.width = old_width 
                awful.placement.align(dock, {
                    position = "center_horizontal"
                })
            end
        end

        if c.type == "dialog" then
            return 
        end
        -- naughty.notify({text = c.class, title=tostring(c.pid)})
        naughty.notify({text = c.class, opacity = 0})
    
        dock.visible = true 
        naughty.destroy_all_notifications() 
        old_width = old_width + 95
        dock.width = old_width
        awful.placement.align(dock, {
            position = "center_horizontal" 
        })
        icon_p = create_app_widget(c)
        icon_cont = wibox.widget{
            widget = wibox.container.margin,
            icon_p,
            left = 10,
            bottom = 18,
            top = 10,
            right = 10,
            id = c.pid,
        }
        icon_cont:buttons(
            gears.table.join(
            awful.button({}, 1, function()
                c:jump_to()
            end )
        ))
        
        icon_p:add_button(awful.button({}, 3, function( )
            pp5 = awful.menu{
                items = {
                    {'Unpin/Pin', function()
                        pinned_apps[c.class] = c 
                        
                    end},
                    {'Kill window', function()
                        c:kill()
                        
                    end}
                }
            
            }
            pp5:toggle()
            -- body
        end))
        
        
        dock_layout:add(icon_cont)
        c:connect_signal("unmanage", function()
            
            naughty.notify({text = c.class, opacity = 0})
            dock_layout:remove_widgets(dock:get_children_by_id(c.pid))
            old_width = old_width - 95
        
            dock.width = old_width
            awful.placement.align(dock, {
                position = "center_horizontal"
            })
            
        end)
        
    end)

    dock:setup{
        layout = dock_layout 
    }
    

    return dock 

    
end


return _M
