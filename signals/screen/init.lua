local awful = require'awful'
local beautiful = require'beautiful'
local wibox = require'wibox'
local gears = require 'gears'
local vars = require'config.vars'
local widgets = require'widgets'
local modules = require 'modules'
local naughty = require 'naughty'
local awedock = require 'modules.awdock' 
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
      }}
   gears.wallpaper.maximized(beautiful.wallpaper, s)



end)
screen.connect_signal('settings::toggle', function()
   for s in screen do 
      if s.settings then
         s.settings:emit_signal("self::toggle")
         
      end
      
   end 
   
end)
local dpi = beautiful.xresources.apply_dpi
screen.connect_signal('request::desktop_decoration', function(s)
   awful.tag(vars.tags, s, awful.layout.suit.tile)
   s.gui_player = widgets.player(s)
   s.promptbox = widgets.create_promptbox()
   s.layoutbox = widgets.create_layoutbox(s)
   s.taglist   = widgets.create_taglist(s)
   s.tasklist  = widgets.create_tasklist(s)
   s.wibox     = widgets.create_wibox(s) 
   s.settings = widgets.settings()
   s.dock = modules.dock.return_dock()
   
   

end)
screen.connect_signal('dock::update', function ()
   for s in screen do 
      if s.dock then
         
         s.dock.emit_signal("apps::update")
      return naughty.notify({text = 'hello from dock::update' })

      end
   
   end
   
end) 