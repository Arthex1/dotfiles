local _M = {}
local naughty = require 'naughty'
local awful = require'awful'
local hotkeys_popup = require'awful.hotkeys_popup'
local beautiful = require'beautiful'
local wibox = require'wibox'
local gears = require 'gears'
local apps = require'config.apps'
local mod = require'bindings.mod'

_M.awesomemenu = {
   {'hotkeys', function() hotkeys_popup.show_help(nil, awful.screen.focused()) end},
   {'manual', apps.manual_cmd},
   {'edit config', apps.editor_cmd .. ' ' .. awesome.conffile},
   {'restart', awesome.restart},
   {'quit', awesome.quit},
}

_M.mainmenu = awful.menu{
   items = {
      {'awesome', _M.awesomemenu, beautiful.awesome_icon},
      {'open terminal', apps.terminal}
   }
}

_M.launcher = awful.widget.launcher{
   image = beautiful.awesome_icon,
   menu = _M.mainmenu
}

_M.keyboardlayout = awful.widget.keyboardlayout()
_M.textclock      = wibox.widget.textclock()
_M.widgetclock      = wibox.widget.textclock()

_M.textclockcontainer =  wibox.widget{
               widget = wibox.container.background,    
               {
                  widget = wibox.container.place,
                  halign = 'center',
                  valign = 'center',   
                  _M.widgetclock
               }, 
               forced_width = 200,
               shape = function(cr, w, h)
                  gears.shape.rounded_rect(cr, w, h, 15)
                  
               end,
               
               
}

_M.widgetclock:connect_signal("mouse::leave", function()
   _M.textclockcontainer.bg = ""
   _M.textclockcontainer.fg = "#d8dee9"
end)
_M.widgetclock:connect_signal("mouse::enter", function()
   _M.textclockcontainer.bg = "#e5e9f066"
   _M.textclockcontainer.fg = "#d8dee9"
   

end)
_M.widgetclock:connect_signal("button::press", function()
   screen.emit_signal("settings::toggle")
   
end)

function _M.create_promptbox() return awful.widget.prompt() end

function _M.create_layoutbox(s)
   return awful.widget.layoutbox{
      screen = s,
      buttons = {
         awful.button{
            modifiers = {},
            button    = 1,
            on_press  = function() awful.layout.inc(1) end,
         },
         awful.button{
            modifiers = {},
            button    = 3,
            on_press  = function() awful.layout.inc(-1) end,
         },
         awful.button{
            modifiers = {},
            button    = 4,
            on_press  = function() awful.layout.inc(-1) end,
         },
         awful.button{
            modifiers = {},
            button    = 5,
            on_press  = function() awful.layout.inc(1) end,
         },
      }
   }
end

function _M.create_taglist(s)
   return awful.widget.taglist{
      screen = s,
      filter = awful.widget.taglist.filter.all,
      buttons = {
         awful.button{
            modifiers = {},
            button    = 1,
            on_press  = function(t) t:view_only() end,
         },
         awful.button{
            modifiers = {mod.super},
            button    = 1,
            on_press  = function(t)
               if client.focus then
                  client.focus:move_to_tag(t)
               end
            end,
         },
         awful.button{
            modifiers = {},
            button    = 3,
            on_press  = awful.tag.viewtoggle,
         },
         awful.button{
            modifiers = {mod.super},
            button    = 3,
            on_press  = function(t)
               if client.focus then
                  client.focus:toggle_tag(t)
               end
            end
         },
         awful.button{
            modifiers = {},
            button    = 4,
            on_press  = function(t) awful.tag.viewprev(t.screen) end,
         },
         awful.button{
            modifiers = {},
            button    = 5,
            on_press  = function(t) awful.tag.viewnext(t.screen) end,
         },
      }
   }
end

function _M.create_tasklist(s)
   return awful.widget.tasklist{
      screen = s,
      filter = awful.widget.tasklist.filter.currenttags,
      buttons = {
         awful.button{
            modifiers = {},
            button    = 1,
            on_press  = function(c)
               c:activate{context = 'tasklist', action = 'toggle_minimization'}
            end,
         },
         awful.button{
            modifiers = {},
            button    = 3,
            on_press  = function() awful.menu.client_list{theme = {width = 250}}   end,
         },
         awful.button{
            modifiers = {},
            button    = 4,
            on_press  = function() awful.client.focus.byidx(-1) end
         },
         awful.button{
            modifiers = {},
            button    = 5,
            on_press  = function() awful.client.focus.byidx(1) end
         },
      }
   }
end

function _M.create_wibox(s)
   return awful.wibar{
      screen = s,
      position = 'top',
      widget = {
         layout = wibox.layout.align.horizontal,
         -- left widgets
         {
            layout = wibox.layout.fixed.horizontal,
            spacing = 1680,
            -- _M.launcher,
            s.taglist,
            s.promptbox,
         },
         
         -- middle widgets
         -- s.tasklist,
         -- right widgets
         {
            layout = wibox.layout.fixed.horizontal,
            -- _M.keyboardlayout,
            -- wibox.widget.systray(),
            hallign = "left",
         
            spacing = 1670,
            _M.textclockcontainer,
            s.layoutbox,
         }
      }
   }
end

function player_shape(cr, w, h)
   gears.shape.rounded_rect(cr,w,h,15)
   
end
local function colorize_text(text, color)
	return "<span foreground='" .. color .. "'>" .. text .. "</span>"
end


function _M.player(s)
   local player = require("signals.player.player") 
   local player_advanced = wibox { bg = "#191724", visible=false, screen=s, input_passthrough = false, type = "dock", ontop = false, x = 30, y = 505, border_width=3, shape=player_shape, width = 403, height = 180, opacity = 1, border_color="#f550e7"}
      local player_widget = wibox.widget {
      image  = "/home/arthex/.config/awesome/icons/spotify.png",
      resize = true,
      forced_height = 80,
      forced_width = 100,
      widget = wibox.widget.imagebox,
      clip_shape = function(cr,w,h)
         gears.shape.rounded_rect(cr,w,h,20)
      end
   }
   
   

   local song_widget = wibox.widget {
      markup = colorize_text("No Song Name!", "#67afc1"),
      -- forced_height = 140,
      -- forced_width = 300,
      font="Poppins,Poppins SemiBold",
      visible = true, 
      opacity = 1, 
     

      widget = wibox.widget.textbox
   }
   local book_widget = wibox.widget {
      markup = colorize_text("No Artist!", "#67afc1"),
      -- forced_height = 140,
      -- forced_width = 300,
      font="Poppins",
      visible = true, 
      opacity = 1, 
     

      widget = wibox.widget.textbox
   }
   skip = wibox.widget{
      widget = wibox.widget.imagebox, 
      image = "/home/arthex/.config/awesome/icons/skip.png",
      forced_height = 40, 
      forced_width = 40,
   }
   previous = wibox.widget{
      widget = wibox.widget.imagebox, 
      image = "/home/arthex/.config/awesome/icons/previous.png",
      forced_height = 40, 
      forced_width = 40,
   }
   local pc = require("modules.bling.signal.playerctl.playerctl_lib")
   
   pause = wibox.widget{
      widget = wibox.widget.imagebox, 
      image = "/home/arthex/.config/awesome/icons/pause.png",
      forced_height = 36, 
      forced_width = 40,
   }
    
   
   skip:connect_signal("button::press", function()

      player:next() 
      
   end)
   previous:connect_signal("button::press", function()
      player:previous()
      
   end)
   playing = 0
   pause:connect_signal("button::press", function()
      if playing == 0 then
         pause.image = "/home/arthex/.config/awesome/icons/play.png"
         playing = 1
      elseif playing == 1 then
         pause.image = "/home/arthex/.config/awesome/icons/pause.png"
         playing = 0
      end 
         
      player:play_pause()
      
      
   end)
   book_widget.point = {x=140, y=68}
   previous.point = {x=195, y=123}
   song_widget.point = {x=140, y=45} 
   player_widget.point = {x=45, y=33}
   skip.point = {x=290, y=123}
   pause.point = {x=244, y=125}
   player_advanced:setup {
      layout = wibox.layout.manual,
      song_widget,
      player_widget,
      book_widget,
      skip, 
      previous,
      pause

   }
   
   
   player:connect_signal("metadata", function(_, title, artist, album_path, album, new, player_name)
      if title and artist then
         book_widget.markup = colorize_text(artist, "#6791c9")
         song_widget.markup = colorize_text(title, "#67afc1")
         if album_path then
            player_widget.image = album_path
         end
      end
      
      
      
      player_advanced.visible = true
   
   end)
   


         
   
   
  

   
  
   return player_advanced
      
   end
_M.settings = require("widgets.settings").create_settings 
return _M
