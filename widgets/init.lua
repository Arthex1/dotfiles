local _M = {}

local awful = require'awful'
local hotkeys_popup = require'awful.hotkeys_popup'
local beautiful = require'beautiful'
local wibox = require'wibox'
local menubar = require 'menubar'
local apps = require'config.apps'
local mod = require'bindings.mod'
local naughty = require 'naughty'
local gears = require 'gears'
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
local bling = require 'modules.bling' 
beautiful.task_preview_widget_border_radius = 12   
beautiful.task_preview_widget_bg = "#4c4f69" 
-- icon_role, name_role, image_role  
bling.widget.task_preview.enable {
    x = 20,                    -- The x-coord of the popup
    y = 20,                    -- The y-coord of the popup
    height = 200,              -- The height of the popup
    width = 200,               -- The width of the popup
    placement_fn = function(c) -- Place the widget using awful.placement (this overrides x & y)
        awful.placement.bottom(c, {
            margins = {
                bottom = 80
            }
        })
    end,
    -- Your widget will automatically conform to the given size due to a constraint container.
    widget_structure = {
        {
            {
                {
                    id = 'icon_role',
                    widget = awful.widget.clienticon, -- The client icon
                },
                {
                    id = 'name_role', -- The client name / title
                    widget = wibox.widget.textbox,
                },
                layout = wibox.layout.flex.horizontal
            },
            widget = wibox.container.margin,
            margins = 5
        },
        {
         widget = wibox.container.margin,
         margins = 50,
         {
            id = 'image_role', -- The client preview
            resize = true,
            valign = 'center',
            halign = 'center',
            widget = wibox.widget.imagebox,
        }},
        layout = wibox.layout.fixed.vertical
    }
}
beautiful.tasklist_bg_minimize = "#ff0000"
function _M.create_tasklist(s)
   return awful.widget.tasklist {
    screen   = s,
    filter   = awful.widget.tasklist.filter.alltags,
    buttons  = {
      awful.button({}, 1, function(c)
         if not c.active then
            c:activate {
               context		= "task_bar",
               switch_to_tag	= true,
            }

         else 
            c.minimized = true

         end

         
      end)
    },
    layout   = {
      pacing_widget = {
            {
                forced_width  = 5,
                forced_height = 24,
                thickness     = 1,
                color         = '#777777',
                widget        = wibox.widget.separator
            },
            valign = 'center',
            halign = 'center',
            widget = wibox.container.place,
        },
        spacing = 1,
        layout  = wibox.layout.fixed.horizontal
    },
    widget_template = {
      -- background_role, clienticon, 
     
      
      {
      widget = wibox.container.margin,
      left = 3,
      right = 3,  
      {
         widget = wibox.container.place,
         halign = 'center',
         valign = 'top',

         {
            widget = wibox.container.background,
            id = 'zombie',
            shape = function(cr, w, h)
               gears.shape.rounded_rect(cr, w, h, 20)

               
            end,
            forced_height = 40,
            forced_width = 40,
            bg = "#e5e9f066",
            {

         
               
            {
               
               widget = awful.widget.clienticon,
               id = 'clienticon',
               forced_height = 25,
               forced_width = 25
            },
            widget = wibox.container.place,
            halign = 'center',
            valign = 'center'
         }
            
         },
         
      }},
      {
            
            wibox.widget.base.make_widget(),
            forced_height = 3,
            id            = 'background_role',
            widget        = wibox.container.background,
      },
      
      --    {
      --       wibox.widget.base.make_widget(),
      --       forced_height = 5,
      --       id            = 'background_role',
      --       widget        = wibox.container.background,
      --   },
      --   {
      --    widget = wibox.container.background,
      --    id = "bgling",
      --    forced_height = 60,
      --    forced_width = 60,
      --    {
      --       {
      --           id     = 'clienticon',
            
      --           widget = awful.widget.clienticon,
      --       },
      --       margins = 5,
      --       widget  = wibox.container.margin
      --   }},
        
        nil,
        create_callback = function(self, c, index, objects) --luacheck: no unused args
            self:get_children_by_id('clienticon')[1].client = c
            
            
            
            -- BLING: Toggle the popup on hover and disable it off hover
            self:connect_signal('mouse::enter', function(ns)
                    self:get_children_by_id('zombie')[1].bg = "#e5e9f0cc"  
                    awesome.emit_signal("bling::task_preview::visibility", s,
                                        true, c)
                              

                end)
                self:connect_signal('mouse::leave', function(ns)
                    self:get_children_by_id('zombie')[1].bg = "#e5e9f066"
                    awesome.emit_signal("bling::task_preview::visibility", s,
                                        false, c)
                    
                end)
        end,
        layout = wibox.layout.align.vertical,
    },
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
      ontop = false,
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
            wibox.widget{
               widget = wibox.container.place,
               halign = 'center',
               s.tasklist
            }
            
         },
         {
            layout = wibox.layout.flex.horizontal,
           
         },
       
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
local desktopapps = require("freedesktop")
for s in screen do
   desktopapps.desktop.add_icons({screen = s}) 
end

return _M

