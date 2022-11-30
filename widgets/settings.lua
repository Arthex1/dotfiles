local _M = {}
local wibox = require('wibox')
local gears = require('gears') 
local awful = require 'awful'
local rubato = require 'rubato'
local beautiful = require 'beautiful'
local naughty = require 'naughty'
local function colorize_text(text, color)
	return "<span foreground='" .. color .. "'>" .. text .. "</span>"
end


function _M.create_settings()
    local settings = wibox{
        visible = false, 
        ontop = true, 
        width = 386, 
        height = 1, 
        type = "dock", 
        x = 1525, 
        y = 40, 
        bg = "#51576d",
        shape = function(cr, w, h)  gears.shape.rounded_rect(cr, w, h, 13)  end}

        
    
    box = wibox.widget{
        widget = wibox.widget.background, 
        bg = '#303446', 
        forced_width = 386, 
        forced_height = 80,
        shape = function(cr, width, height)
            gears.shape.partially_rounded_rect(cr, width, height, false, false, true, true, 13)
            
        end
        
    }
    

    volume = wibox.widget {
        widget = wibox.widget.textbox,
        markup = colorize_text('墳', "#d8dee9"),
        -- forced_height = 1, 
        --  forced_width = 1,
        font = 'Iosevka,Iosevka Nerd Font 14',

    }

    

    
    volume_slider = wibox.widget {
        -- bar_height = 6,
        bar_active_color = "#3481be",
        bar_color = "#64786a",
        value               = 10,
        maximum = 153,
        minimum = 0,
        forced_width = 230,
        forced_height = 8,
        handle_width = 8,
        handle_shape = gears.shape.circle,
        handle_color  = "#e4f1f4",
        bar_shape = function(cr, w, h)
            gears.shape.partially_rounded_rect(cr, w, h, false, true, true, false, 3 )
        end ,
        widget              = wibox.widget.slider,
    } 
    
    brightness = wibox.widget {
        widget = wibox.widget.textbox,
        markup = colorize_text('', "#d8dee9"),
        font = 'Iosevka,Iosevka Nerd Font 13',
    }
    brightness_slider = wibox.widget {
        -- bar_height = 6,
        bar_active_color = "#3481be",
        bar_color = "#64786a",
        value               = 10,
        maximum = 100,
        minimum = 0,
        forced_height = 8,
        forced_width = 230,
        handle_width = 8,
        handle_shape = gears.shape.circle,
        handle_color  = "#e4f1f4",
         bar_shape = function(cr, w, h)
            gears.shape.partially_rounded_rect(cr, w, h, false, true, true, false, 3 )
        end ,
        widget              = wibox.widget.slider,
    }

    volume.point = {x=49.7,y=303}
    brightness.point = {x=48, y=340}
    volume_slider.point = {x=90, y=311}
    brightness_slider.point = {x=90, y=347}

    -- volume_slider:connect_signal("property::value", function(_, new_value)
         
    
    -- end)
    volume_container = wibox.widget{
        widget = wibox.widget.background, 
        bg = '#303446', 
        forced_width = 350, 
        forced_height = 90,
        shape = function(cr, width, height)
            gears.shape.partially_rounded_rect(cr, width, height, true, true, true, true, 13)
            
        end,
       
    }
   
    
    box.point = {x=0, y=335}
    volume_container.point = {x=18, y=290}
    
    brightness_slider:connect_signal("property::value", function(_, val)
       awful.spawn("brightnessctl s " .. tostring(val) .. "%" )
      
    end)

    awesome.connect_signal("signal::volume", function(volume_int, muted)
       
        volume_slider.value = volume_int
        
    end) 

    awesome.connect_signal("signal::brightness", function(per)
        brightness_slider.value = per 
        
    end)

    volume_slider:connect_signal("property::value", function(_, new_value)
        awful.spawn("amixer -D pulse set Master " .. new_value .."%", false)
        
    end)



    -- Helpers 

    local function get_battery_icon(percentage)
        if percentage < 15 then
            return ""
        elseif percentage < 30 then
            return ""
            
        elseif percentage < 50 then
            return ""
        elseif percentage < 65 then 
            return ""
        elseif percentage < 75 then 
            return ""
        elseif percentage < 85 then 
            return ""
        elseif percentage < 100 then 
            return "" 
        else 
            return "" 

        end 
        
    end

    -- Widgets

    wifi_icon = wibox.widget{
                markup = colorize_text("睊", "#d8dee9"),
                widget = wibox.widget.textbox,
                id = "icon", 
                font = 'Iosevka,Iosevka Nerd Font 17'
    }
    wifi = wibox.widget{
        widget = wibox.widget.background, 
        bg = '#303446', 
        forced_width = 170, 
        forced_height = 90,
        shape = function(cr, width, height)
            gears.shape.partially_rounded_rect(cr, width, height, true, true, true, true, 13)
            
        end,
        wibox.widget{
            halign = 'center',
            valign = 'center',
            id = "container",
            widget = wibox.container.place,
            wifi_icon,
        }
        
       
    }
    settings_cont = wibox.widget{
        widget = wibox.widget.background, 
        bg = '#303446', 
        forced_width = 60, 
        forced_height = 60,
        shape = function(cr, width, height)
            gears.shape.circle(cr, width, height, 15)
            
        end,
        
       
    }
    bluetooth_icon =  wibox.widget{
        markup = colorize_text("", "#d8dee9"),
        widget = wibox.widget.textbox,
        font = 'Iosevka,Iosevka Nerd Font 19',
        id = "icon"

    }    
    bluetooth = wibox.widget{
        widget = wibox.widget.background, 
        bg = '#303446', 
        forced_width = 170, 
        forced_height = 90,
        shape = function(cr, width, height)
            gears.shape.partially_rounded_rect(cr, width, height, true, true, true, true, 13)
            
        end,
        wibox.widget{    
            halign ='center',
            valign = 'center',
            id = "container", 
            widget = wibox.container.place, 
            bluetooth_icon   
        }
    }

    wifi_text = wibox.widget{
        widget = wibox.widget.textbox, 
        markup = colorize_text("none", "#d8dee9"),
        font = "Poppins 8",
        visible = false 
    }
    bluetooth_text = wibox.widget{
        widget = wibox.widget.textbox, 
        markup = colorize_text("none", "#d8dee9"),
        font = "Poppins 8", 
        visible = false
    }
    active_bluetooth = ""
    
    active_wifi = ""
    


    -- Points/Placements 

    wifi.point = {x=18, y=190}
    bluetooth.point = {x=197, y=190}
    wifi_text.point = {x=90.5, y=260}
    bluetooth_text.point = {y=260, x=267}
    bluetooth_active = false
    wifi_active = false 
    settings_cont.point = {y=4, x=310}
    -- Signals 
    
    bluetooth:connect_signal("self::toggle", function()
        if bluetooth_active then
           bluetooth_active = false 
           bluetooth.bg = "#303446"
           bluetooth_text.visible = false
           bluetooth_icon.markup = colorize_text("", "#d8dee9")
        
        else
           bluetooth_active = true
           bluetooth.bg = "#3481be"
           bluetooth_icon.markup = colorize_text("", "#d8dee9")
        --    bluetooth_text.visible = true 
 
        end
        
    end)

    wifi:connect_signal("self::toggle", function()
        if wifi_active then
           wifi_active = false 
           wifi.bg = "#303446"
            wifi_text.visible = false
            wifi_icon.markup = colorize_text("睊", "#d8dee9")
          
        else
           wifi_active = true
           wifi.bg = "#3481be"
           wifi_icon.markup = colorize_text("直", "#d8dee9")
        --    wifi_text.visible = true 
 
        end
        
    end)









    wifi:connect_signal("button::press", function()
        wifi:emit_signal("self::toggle")
        
    end)
    wifi:connect_signal("mouse::enter", function()
        if wifi_active then
            wifi.bg = "#326ec28a"
            return 
        else 
            wifi.bg = "#e5e9f066"
            wifi_icon.markup = colorize_text("睊", "#326ec2")
        end 
    end)
    wifi:connect_signal("mouse::leave", function()
        if wifi_active then 
            wifi.bg = "#3481be"
            wifi_icon.markup = colorize_text("直", "#d8dee9")
        else 
            wifi.bg = "#303446"
            wifi_icon.markup = colorize_text("睊", "#d8dee9")
        end
    end)


    bluetooth:connect_signal("mouse::enter", function()
        if bluetooth_active then
            bluetooth.bg = "#326ec28a"
            return 

        else 
        
            bluetooth.bg = "#e5e9f066"
            bluetooth_icon.markup = colorize_text("", "#326ec2")
        end 
    end)
    bluetooth:connect_signal("mouse::leave", function()
        if bluetooth_active then 
            bluetooth.bg = "#3481be"
            bluetooth_icon.markup = colorize_text("", "#d8dee9")
        else 
            bluetooth.bg = "#303446"
            bluetooth_icon.markup = colorize_text("", "#d8dee9")
        end 
    end)
    bluetooth:connect_signal("button::press", function()
        bluetooth:emit_signal("self::toggle")
       
        
    end)

    
    -- awesome.connect_signal("signal::bluetooth", function(c, b)
    --     naughty.notify({text = tostring(c)})
        
    -- end)












    settings:setup {
        layout = wibox.layout.manual,
        
        volume_container,
        volume_slider,
        volume,
        brightness,
        brightness_slider,
        bluetooth,
        wifi, 
        bluetooth_text,
        wifi_text,
        -- settings_cont
    }
   local settings_slide = rubato.timed {
        pos        = 1,
        duration   = 0.4,
        intro      = 0.2,
        outro      = 0.1,
        easing     = rubato.quadratic,
        subscribed = function(pos, target)
            
            if pos < 1 then
                return 
            end
            settings.height = pos
            
            
        end
    }
    
    settings:connect_signal("self::toggle", function()
        if settings.visible then
            
            settings_slide.target = 2
            settings.visible = false 
        else 
            settings.visible = true 
            settings_slide.target = 400
        end
        
    end) 

    return settings 
    
    
end
return _M 
