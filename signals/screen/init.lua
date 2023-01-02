local awful = require'awful'
local beautiful = require'beautiful'
local wibox = require'wibox'

local vars = require'config.vars'
local widgets = require'widgets'


local naughty = require 'naughty'
screen.connect_signal('request::wallpaper', function(s)
   awful.wallpaper{
      screen = s,
      widget = {
         {
            image     = beautiful.wallpaper,
            upscale   = true,
            downscale = true,
            widget    = wibox.widget.imagebox,
         },
         valign = 'center',
         halign = 'center',
         tiled = false,
         widget = wibox.container.tile,
      }

   }
end)
screen.connect_signal("toggle::launcher", function()
   for i in screen do 
      if i.launcher then
         i.launcher:emit_signal("self::toggle")
      end
      
   end
   
end)
screen.connect_signal("toggle::switcher", function()
   for i in screen do 
      if i.tagswitcher then
         i.tagswitcher:emit_signal("self::toggle")
      end
   end
end)
screen.connect_signal("toggle::mainmenu", function()
   for i in screen do 
      if i.mainmenu then
         i.mainmenu:toggle()
      end
   end  
   
end)

screen.connect_signal('request::desktop_decoration', function(s)
   awful.tag(vars.tags, s, awful.layout.layouts[2])
   s.promptbox = widgets.create_promptbox()
   s.layoutbox = widgets.create_layoutbox(s)
   s.taglist   = widgets.create_taglist(s)
   s.tasklist  = widgets.create_tasklist(s)
   s.wibox     = widgets.create_wibox(s)
   s.launcher = widgets.launcher.init{}
   s.mainmenu = require 'widgets.menu'
   s.tagswitcher = widgets.tagswitcher.init(s)
     
end)
