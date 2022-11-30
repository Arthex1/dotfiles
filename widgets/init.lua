local _M = {}

local awful = require'awful'
local hotkeys_popup = require'awful.hotkeys_popup'
local beautiful = require'beautiful'
local wibox = require'wibox'
local menubar = require 'menubar'
local apps = require'config.apps'
local mod = require'bindings.mod'
local naughty = require 'naughty'

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
   local launcher = wibox.widget{
      widget = wibox.container.background, 
      -- bg = "#e5e9f066", 
      forced_width = 60,
      wibox.widget{
            widget = wibox.container.place,
            wibox.widget{
               widget = wibox.widget.imagebox, 
               -- resize = true,
               forced_height = 33,
               forced_width = 33,
               image = "/home/arthex/.config/awesome/icons/arch.png"
            }  
      },
      
   }
   launcher:connect_signal("mouse::enter", function()
      launcher.bg = "#e5e9f066"
      
   end)
   launcher:connect_signal("mouse::leave", function()
      launcher.bg = ""
      
   end)
   launcher:buttons{
      awful.button({}, 1, function()
         awful.spawn("/home/arthex/.config/rofi/launchers/type-3/launcher.sh")

         
      end),
      awful.button({}, 3, function()
         naughty.notify({text = "This feature hasnt been implemented yet!"})
         
      end)
   }

   return awful.wibar{
      screen = s,
      height = 50,
      ontop = true,
      position = 'bottom',
      bg = "#292c3c8c",
      widget = {
         layout = wibox.layout.align.horizontal,
         {
          layout = wibox.layout.flex.horizontal, 
          launcher,
          
         },
         {
            layout = wibox.layout.flex.horizontal, 
         },
         {
            layout = wibox.layout.flex.horizontal,
           
         },


         -- left widgets
         -- {
         --    layout = wibox.layout.fixed.horizontal,
         --    _M.launcher,
         --    s.taglist,
         --    s.promptbox,
         -- },
         -- middle widgets
       
         -- right widgets
      --    {
      --       layout = wibox.layout.fixed.horizontal,
      --       _M.keyboardlayout,
      --       wibox.widget.systray(),
      --       _M.textclock,
      --       s.layoutbox,
      --    }
       }
   }
end

return _M
