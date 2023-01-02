
local wibox = require 'wibox'
local naughty = require 'naughty'
local gears = require 'gears'
local awful = require 'awful'
local beautiful = require 'beautiful'
local inputtable = require 'modules.inputbox' 


function colorize_text(text, color)
	return "<span foreground='" .. color .. "'>" .. text .. "</span>"
end


local function create_launcher(width, height, icon_theme, x, y, ontop, bg) 
    local launcher = wibox{
        visible = false, 
        type = "dock", 
        height = height, 
        shape = function(cr, w, h)
            gears.shape.rounded_rect(cr, w, h, 11)
        end,
        width = width, 
        x = x, 
        bg = "#2e2e2e",
        y = y, 
        ontop = true
    }
    local launcher_apps = wibox{
        visible = false, 
        type = "dock",
        height = height - 2,
        width = width * 6,
        shape = launcher.shape, 
        ontop = true, 
        bg = launcher.bg,
        y = launcher.y,
        x = launcher.x + 80,

    }
    --
    local pfpicon = {
        widget = wibox.container.place,
        halign = 'center',
        {
            widget = wibox.container.margin,
            top = 15,
            {
                widget = wibox.container.background,
                shape = gears.shape.circle,
                forced_width = 30,
                forced_height = 30,
                bg = "",
                {
                    widget = wibox.widget.imagebox,
                    image = "/home/arthex/.config/awesome/icons/pfp.png",
                    resize = true,
                }
            }
        }
    }
  
    local restarticon = {
        
        widget = wibox.container.place, 
        halign = 'center',
        valign = 'bottom',
        {
            widget = wibox.container.margin,
            top = 315,
            
            {
                widget = wibox.container.background,
                forced_width = 30,
                forced_height = 30,
                id = "refresh_bg",
                shape = function(cr, w, h)
                    gears.shape.rounded_rect(cr, w, h, 3)
                    
                end,
                {
                    widget = wibox.container.place,
                    halign = 'center',
                    valign = 'center',
                    {
                        widget = wibox.widget.textbox,
                        markup = colorize_text("", "#d8dee9"),
                        font = 'tabler-icons 19'
                    }
                }
            }
        }
    }
    
    local exiticon = {
        
        widget = wibox.container.place, 
        halign = 'center',
        valign = 'bottom',
        {
            widget = wibox.container.margin,
            
            
            {
                widget = wibox.container.background, 
                -- bg = "#000000",
                forced_width = 30,
                forced_height = 30,
                id = "exit_bg", 
                shape = function(cr, w, h)
                    gears.shape.rounded_rect(cr, w, h, 3)
            
                end,
                {
                    widget = wibox.container.place,
                    halign = 'center',
                    valign = 'center',
                    {
                        widget = wibox.widget.textbox, 
                        markup = colorize_text("", "#d8dee9"),
                        font = "tabler-icons 19"
                }}
        }
    }}


   







    launcher:setup{
        layout = wibox.layout.fixed.vertical,
        spacing = 10,
        pfpicon,
        restarticon,
        exiticon,
        
        
    }

    -- exit_bg-signals
    launcher:get_children_by_id("exit_bg")[1]:connect_signal("mouse::enter", function()
        launcher:get_children_by_id("exit_bg")[1].bg = beautiful.transparent_bg
        
    end )
    launcher:get_children_by_id("exit_bg")[1]:connect_signal("mouse::leave", function()
        launcher:get_children_by_id("exit_bg")[1].bg = ""
        
    end )
    launcher:get_children_by_id("exit_bg")[1]:connect_signal("button::press", function()
        create_yes_or_no_popup("Do you really want to quit?", "AwesomeWM")
        
    end)

    -- refresh-bg-signals
    launcher:get_children_by_id("refresh_bg")[1]:connect_signal("mouse::enter", function()
        launcher:get_children_by_id("refresh_bg")[1].bg = beautiful.transparent_bg
        
    end )
    launcher:get_children_by_id("refresh_bg")[1]:connect_signal("mouse::leave", function()
        launcher:get_children_by_id("refresh_bg")[1].bg = ""
        
    end )
    launcher:get_children_by_id("refresh_bg")[1]:connect_signal("button::press", function()
        create_yes_or_no_popup("Do you really want to restart?", "AwesomeWM")
        
    end)

    launcher:connect_signal("self::toggle", function()
        launcher.visible = not launcher.visible
        launcher_apps.visible = not launcher_apps.visible
    end)


    -- Setup and widgets of launcher_apps 

    local search = {
        widget = wibox.container.background,
        forced_height = 70,
        bg = launcher_apps.bg,
        border_width = 1.2,
        border_strategy = "inner",
        border_color = "#2e2e2ee3",
        
        shape = function(cr, w, h)
            gears.shape.partially_rounded_rect(cr, w, h, true, true, false, false, 11)
        end,
        {
            widget = wibox.container.place,
            {
                
                widget = wibox.container.background,
                forced_height = 40,
                forced_width = 290,
                bg = "#2e2e2ee3",
                shape = function(cr, w, h)
                    gears.shape.rounded_rect(cr, w, h, 6)
                    
                end,
                
                {
                    widget = wibox.container.place,
                    {
                        
                        widget = awful.widget.prompt{
                            execute = "Hello: "
                        }

                    }
                    
                }
            }

        }
    }
    
    
    
    launcher_apps:setup{
        layout = wibox.layout.fixed.vertical,
        search
    }

    return launcher
end


local function init(args)
    local width = args.width or 60
    local height = args.height or 450
    local bg = args.bg or "#292c3c8c"
    local icon_theme = args.theme or "Colloid-pink-dark" 
    local x = args.x or 10
    local ontop = args.ontop or true 
    
    local y = args.y or 570
    return create_launcher(width, height, icon_theme, x, y, bg) 
    
    
end 


function create_yes_or_no_popup(msg, title)
        local yes = wibox.widget{
                        widget = wibox.container.background,
                        shape = function(cr, w, h)
                            gears.shape.rounded_rect(cr, w, h, 7) 
                            
                        end,
                    
                        bg = "#303446",
                        forced_width = 150,
                        forced_height = 60,
                        {
                            widget = wibox.container.place,
                            halign = 'center',
                            valign = 'center',
                            {
                                widget = wibox.widget.textbox,
                                markup = colorize_text("Yes", "#d8dee9"),
                                font = 'Poppins,Poppins Semibold 14'
                            }
                        }
                        }

        yes:connect_signal("mouse::enter", function()
            yes.bg = "#626880"
            
        end)
        yes:connect_signal("mouse::leave", function()
            yes.bg = "#303446"
            
        end)
        local no = wibox.widget{
                        widget = wibox.container.background,
                        shape = function(cr, w, h)
                            gears.shape.rounded_rect(cr, w, h, 7) 
                            
                        end,
                    
                        bg = "#303446",
                        forced_width = 150,
                        forced_height = 60,
                        {
                            widget = wibox.container.place,
                            halign = 'center',
                            valign = 'center',
                            {
                                widget = wibox.widget.textbox,
                                markup = colorize_text("No", "#d8dee9"),
                                font = 'Poppins,Poppins Semibold 14'
                            }
                        }
                        }

        no:connect_signal("mouse::enter", function()
            no.bg = "#626880"
            
        end)
        no:connect_signal("mouse::leave", function()
            no.bg = "#303446"
            
            
        end)
        local p4 = awful.popup {
             widget = wibox.widget {
                layout = wibox.layout.align.vertical,
                {
                    widget = wibox.container.background,
                    forced_height = 30,
                    bg = "#292c3c",
                    {
                        widget = wibox.container.place,
                        halign = 'center',
                        valign = 'center',

                        {
                            
                            markup = colorize_text(title, "#d8dee9"),
                            font = "Poppins,Poppins Semibold 10",

                            
                            widget = wibox.widget.textbox
                        }
                    },
                },
                {
                widget = wibox.container.place,
                    valign = 'top',
                {
                    widget = wibox.container.margin,
                    bottom = 0,
                    left = 100,
                    top = 20,
                    right = 100,
                    {

                        widget = wibox.widget.textbox, 
                        markup = colorize_text(msg, "#d8dee9"),
                        font = 'Poppins 15'
                    }
                }},
                {
                    widget = wibox.container.place, 
                    
                    {
                        widget = wibox.container.margin,
                        bottom = 20,
                        left = 0,
                        right = 265,
                
                        yes
                    }
                },
                {
                    widget = wibox.container.place, 
                    
                    {
                        widget = wibox.container.margin,
                        bottom = 20,
                        right = 0,
                        left = 0,
                        
                
                        no
                    }
                }
                
                

        },
            ontop = true, 
            placement = "centered",
            hide_on_right_click = true, 
            shape = function(cr, w, h)
                gears.shape.rounded_rect(cr, w, h, 8)
            end,
            bg = "#232634",
            minimum_width = 450,
            minimum_height = 180,
            border_color        = '#777777',
            border_width        = 2,
            preferred_positions = 'right',
            preferred_anchors   = {'front', 'back'},
        }
        
        
   
    
end


return {
    init = init 
}