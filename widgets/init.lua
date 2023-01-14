local _M = {}

local awful = require'awful'
local hotkeys_popup = require'awful.hotkeys_popup'
local beautiful = require'beautiful'
local wibox = require'wibox'
local gears = require 'gears'
local apps = require'config.apps'
local naughty = require 'naughty'
local mod = require'bindings.mod'
local misc = require 'helpers.misc'
local animations = require 'helpers.animations'
local Gio = require 'lgi'.require('Gio', '2.0')
local bling = require 'modules.bling'
local pinmanager = require 'widgets.pinmanager'
 local appiconhelper = require('modules.bling.helpers.icon_theme')(beautiful.tasklist_icon_theme, beautiful.tasklist_icon_size)
_M.awesomemenu = {
   {'hotkeys', function() hotkeys_popup.show_help(nil, awful.screen.focused()) end},
   {'manual', apps.manual_cmd},
   {'edit config', apps.editor_cmd .. ' ' .. awesome.conffile},
   {'restart', awesome.restart},
   {'quit', awesome.quit},
}

_M.pinned_apps = wibox.layout{layout = wibox.layout.flex.horizontal, spacing = 5}

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










local function create_pinned_app_template(args, handlers)
   local widget_template = wibox.widget{
      
      {
         widget = wibox.container.margin, 
         left = beautiful.tasklist_pinned_spacing,
         right = beautiful.tasklist_pinned_spacing,
         bottom = beautiful.tasklist_pinned_bottom_margin,
      {
         widget = wibox.container.background, 
         id = "bgdis", 
         -- bg = beautiful.transparent_bg, 
         forced_height = beautiful.tasklist_bg_height,
         forced_width = beautiful.tasklist_bg_width, 
         {
         widget = wibox.container.place,
            {
            widget = wibox.widget.imagebox, 
            image = args.icon,
            forced_height = beautiful.tasklist_icon_height, 
            forced_width = beautiful.tasklist_icon_width , 
            id = "app_icon",
            }
      }
      },
   
        
              
               
      },
        layout = wibox.layout.stack,
        id = args.cname
    }
   
   widget_template:connect_signal('mouse::enter', function() 
      widget_template:get_children_by_id('bgdis')[1].bg = beautiful.tasklist_hover_color
      if handlers.mouse_enter then
         handlers.mouse_enter(widget_template)
      end
   end)
   widget_template:connect_signal('mouse::leave', function()
      widget_template:get_children_by_id('bgdis')[1].bg = ''
      if handlers.mouse_leave then
         handlers.mouse_leave(widget_template)
      end
   end)
   return widget_template
   
end

















function _M.create_tasklist(s)
   app = awful.widget.tasklist {
    screen   = s,
    filter   = awful.widget.tasklist.filter.alltags,
    buttons  = tasklist_buttons,
    layout   = {
       
        spacing = beautiful.tasklist_spacing,
        layout  = wibox.layout.fixed.horizontal
    },
    -- Notice that there is *NO* wibox.wibox prefix, it is a template,
    -- not a widget instance.
    widget_template = {
      
         widget = wibox.container.margin, 
        
      {
         widget = wibox.container.background, 
         id = "bgdis", 
         -- bg = beautiful.transparent_bg, 
         forced_height = beautiful.tasklist_bg_height,
         forced_width = beautiful.tasklist_bg_width, 
         {
         widget = wibox.container.place,
            {
            widget = wibox.widget.imagebox, 
            forced_height = beautiful.tasklist_icon_height, 
            forced_width = beautiful.tasklist_icon_width , 
            id = "app_icon",
            }
      }
      },
      {
         widget = wibox.container.margin, 
         id = "margin_bg",
         top = beautiful.tasklist_bg_ind_height,
          {
         wibox.widget.base.make_widget(), 
         widget = wibox.container.background, 
         id = "background_role"
         }
      },
        
              
               
              
               
      
               

            

   
        
        create_callback = function(self, c, _, _) 
            self:get_children_by_id('app_icon')[1].image = appiconhelper:get_client_icon_path(c)
            self:get_children_by_id('layout')[1]:raise_widget(self:get_children_by_id('layout')[1]:get_children_by_id('margin_bg')[1])


            local popup = awful.tooltip { 
               bg = beautiful.tasklist_hover_tooltip_bg, 
               forced_height = 400,
               forced_width = 400,
               objects = { self}
            }
            self:buttons{
               awful.button({}, 1, function()
                    if not c.active then
                       c:activate {
                           context         = "task_bar",
                           switch_to_tag   = true,
                       }

                    else 
                       c.minimized = true

                    end
               end),
               awful.button({}, 3, function()
                  awful.menu{items = {
                     {'Pin App to Taskbar', function()
                        pinmanager.CreateApp(c)
                        
                     end} 
                     
                  }}:toggle()
                 
               end)
            }

         
         
            self:connect_signal('mouse::enter', function()
               
               popup.text = c.name
               if c.active then
                  self:get_children_by_id('bgdis')[1].bg = beautiful.tasklist_active_hover_color
                  return
               end
               self:get_children_by_id('bgdis')[1].bg = beautiful.tasklist_hover_color
               
            end)
            self:connect_signal('mouse::leave', function()
              
               if c.active then
                  return 
               end
               self:get_children_by_id('bgdis')[1].bg = ""
               
            end)
            c:connect_signal('focus', function()
               self:get_children_by_id('bgdis')[1].bg = beautiful.transparent_bg 
               
            end)
            c:connect_signal('unfocus', function()
               self:get_children_by_id('bgdis')[1].bg = ''
               
            end)
            awesome.connect_signal('startup', function() 
               self:get_children_by_id('bgdis')[1].bg = ''
               if c.active then
                  self:get_children_by_id('bgdis')[1].bg = beautiful.transparent_bg
               end
               
            end)
        end,   
        layout = wibox.layout.stack,
        id = "layout"
    },
   }
   return app
end

function _M.create_wibox(s)
   local bar = awful.wibar{
      screen = s,
      height = beautiful.taskbar_height,
      position = 'bottom',
      ontop = true,
      bg = beautiful.taskbar_bg, 
      widget = {
         layout = wibox.layout.flex.horizontal, 
         {
            layout = wibox.layout.flex.horizontal
         },
         {
           layout = wibox.layout.align.horizontal,
           _M.pinned_apps,
            {
               widget =  s.tasklist, 
               align = 'center'
            }
            



               
            
         }
      }
   }

   client.connect_signal("property::fullscreen", function(c)
      bar.visible = not c.fullscreen
      
   end)
   awesome.connect_signal('pin::add', function(args) 

     
      template = create_pinned_app_template(args, {
         mouse_enter = function(self)
            
            local popup = awful.tooltip { 
               bg = beautiful.tasklist_hover_tooltip_bg, 
               forced_height = 400,
               forced_width = 400,
               objects = { self}
            }
            popup.text = args.cname 
         end, 
      }) 
       template:buttons{
         awful.button({}, 1, function()
            misc.double_click_event_handler(function()
               Gio.AppInfo.launch_uris_async(Gio.AppInfo.create_from_commandline(args.exec, nil, 0))
 
            end)
         end), 
         awful.button({}, 3, function()
            awful.menu({
               items = {
                  {"Remove From Taskbar", function()
                     _M.pinned_apps.children =  pinmanager.UpdateTable(_M.pinned_apps, args.cname)
                     pinmanager.DeleteApp(args.cname)
                  end}
               }
            }):toggle()
         end)
       }
       if pinmanager.add_add_to_template(args.cname) then 
         _M.pinned_apps:add(template) 
       end
      client.connect_signal('manage', function(c) 
         if string.lower(args.cname) == string.lower(c.class) then
            -- _M.pinned_apps:remove_widgets(template)
            _M.pinned_apps.children =  pinmanager.UpdateTable(_M.pinned_apps, args.cname)
         end 
         
         
      end)

      client.connect_signal('unmanage', function(c)
         if string.lower(args.cname) == string.lower(c.class) then
            if pinmanager.add_add_to_template(args.cname) then
               _M.pinned_apps:add(template)
            end
         end
      end)
   end)
   -- awesome.connect_signal('update::theme', function(theme)
   --    if theme == "dark" then 
   --       bar.bg = "#fff555"
   --    elseif theme == "light" then 
   --       bar.bg = "#000000"
   --    else 
   --       naughty.notify({text = tostring('Theme provided isnt valid: Bar')})
   --    end 

      
   -- end)
   return bar 
end





return _M
