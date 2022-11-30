local awful = require'awful'
require'awful.autofocus'
local naughty = require 'naughty'
local wibox = require'wibox'
local beautiful = require 'beautiful'
local gears = require 'gears'
local dock = require 'modules.dock.init'
local bling_icon_helper = require("modules.bling.helpers.icon_theme")
local icon_theme = bling_icon_helper("Qogir", 48)
client.connect_signal('mouse::enter', function(c)
   c:activate{context = 'mouse_enter', raise = false}
end)
beautiful.excluded_titlebars = {"starterm", "clock", "kitty"}
beautiful.titlebar_bg_normal = "#1e1e2e"
beautiful.titlebar_bg_focus = "#1e1e2e"
local function colorize_text(text, color)
	return "<span foreground='" .. color .. "'>" .. text .. "</span>"
end
function titleCase( first, rest )
   return first:upper()..rest:lower()
end
function val_str(stro)
   stro = stro or "55"
   return string.gsub(stro, "(%a)([%w_']*)", titleCase)
end


client.connect_signal('request::titlebars', function(c)
   for i, v in ipairs(beautiful.excluded_titlebars) do
      if c.class == v then
         return 
      end
      
   end
   local close_button = wibox.widget {
      image = "/home/arthex/.config/awesome/icons/close.png",
      widget = wibox.widget.imagebox,
      resize = true,
      forced_height = 20,
      forced_width = 60,
   }
   close_button:connect_signal("button::press", function()
      
      if c.pid then
         awful.spawn.with_shell("kill -9 " .. c.pid)
      end
      
   end)
   close_button:connect_signal("mouse::enter", function()
      close_button.image = "/home/arthex/.config/awesome/icons/close_button.png"

   end)
   close_button:connect_signal("mouse::leave", function()
      close_button.image = "/home/arthex/.config/awesome/icons/close.png"
      
   end)
   close_button.point = {x=15, y=5}
   local min_button = wibox.widget {
      image = "/home/arthex/.config/awesome/icons/min.png",
      widget = wibox.widget.imagebox,
      resize = true,
      forced_height = 20,
      forced_width = 60,
   }
   min_button:connect_signal("button::press", function()
      awful.client.floating.toggle()
      
      
   end)
   min_button:connect_signal("mouse::enter", function()
      min_button.image = "/home/arthex/.config/awesome/icons/min_button.png"
      
   end)
   min_button:connect_signal("mouse::leave", function()
      min_button.image = "/home/arthex/.config/awesome/icons/min.png"
      
   end)
   min_button.point = {x=40, y=5}

   local fullscreen_button = wibox.widget {
      image = "/home/arthex/.config/awesome/icons/fullscreen.png",
      widget = wibox.widget.imagebox,
      resize = true,
      forced_height = 20,
      forced_width = 60,
   }
   fullscreen_button:connect_signal("button::press", function()
            c.fullscreen = not c.fullscreen
            c:raise()
      
   end)
   fullscreen_button:connect_signal("mouse::enter", function()
      fullscreen_button.image = "/home/arthex/.config/awesome/icons/fullscreen_button.png"
      
   end)
   fullscreen_button:connect_signal("mouse::leave", function()
      fullscreen_button.image = "/home/arthex/.config/awesome/icons/fullscreen.png"
      
   end)
   fullscreen_button.point = {x=65, y=5}
   -- buttons for the titlebar
   local buttons = {
      awful.button{
         modifiers = {},
         button    = 1,
         on_press  = function()
            c:activate{context = 'titlebar', action = 'mouse_move'}
         end
      },
      awful.button{
         modifiers = {},
         button    = 3,
         on_press  = function()
            c:activate{context = 'titlebar', action = 'mouse_resize'}
         end
      },
   }
   title_c = wibox.widget {
      
         markup = colorize_text(val_str(c.class), "#e5e9f0"),
         -- forced_height = 140,
         -- forced_width = 300,
         font="Poppins,Poppins SemiBold",
         visible = true, 
         opacity = 1, 
         widget = wibox.widget.textbox
         }
   title_c.point = awful.placement.centered
   
   local tit = awful.titlebar(c, {
      -- left
      height = 35,
      size = 35,
      bg_normal = "#181825",
      bg_focus = "#181825",
   }) 

   tit:setup {
      {
         layout  = wibox.layout.flex.horizontal,
         
      },
      
        
        {
         
         {
            widget = title_c,
            placement = ""
         },
         layout  = wibox.layout.manual,
         buttons = buttons  

      },

      
      { 
         {
            widget = min_button
         },
         {
         
            widget = close_button,
         },
         {
            widget = fullscreen_button
         },
         layout = wibox.layout.manual,
         spacing = 10,
      },
      layout = wibox.layout.manual, 
   }
end)

function dock_update(c)
if c.icon then
            if c.class == "clock" then
               return 
            end
            if c.class == "starterm" then
               return 
            end
            for k, v in pairs(beautiful.dock_apps) do
               if k == c.class then
                  return  
               end

               
            end

            beautiful.dock_apps[c.class] = c.icon
            screen.emit_signal("dock::update") 
            
            
            
         end 
   
end
beautiful.pink_apps = {"kitty", "starterm", "clock"}
client.connect_signal("focus", function(c) 
   for i, v in ipairs(beautiful.pink_apps) do
      if c.class == v then
         c.border_color = "#f550e7"
         return 
      end 
   end 
   c.border_color = "#181825"
   -- dock_update(c)
   
   -- os.execute("sleep 3")
   -- client.emit_signal("focus", c)
   end
   

)
beautiful.rounded_apps = {"kitty", "starterm", "clock"}
client.connect_signal("manage", function (c)
   for i, v in ipairs(beautiful.rounded_apps) do
   if c.class == v then
      c.shape = function(cr,w,h)
            gears.shape.partially_rounded_rect(cr,w,h, true, true, true, true, 15)
      end 
      return
   end
   end 
   
   c.shape = function(cr,w,h)
         gears.shape.partially_rounded_rect(cr,w,h, true, true, true, true, 10)
   end 
   return
  
end)
client.connect_signal("unmanage", function(c)
   if c.class == 'Spotify' then 
      for s in screen do 

         if s.gui_player then
            s.gui_player.visible = false
            
         end
         
         
      end
   end 
   
   
end)
