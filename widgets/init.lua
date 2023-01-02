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
local Gio = require 'lgi'.Gio
local pinmanager = require 'widgets.pinmanager'
_M.awesomemenu = {
   {'hotkeys', function() hotkeys_popup.show_help(nil, awful.screen.focused()) end},
   {'manual', apps.manual_cmd},
   {'edit config', apps.editor_cmd .. ' ' .. awesome.conffile},
   {'restart', awesome.restart},
   {'quit', awesome.quit},
}


beautiful.main_menu_bg = "#2e3440"
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
beautiful.tasklist_bg_minimize = "#d20f39"
beautiful.tasklist_bg_focus = "#209fb5"
beautiful.tasklist_bg_normal = "#626880"
beautiful.transparent_bg = "#e5e9f066"
local icon_helper = require('modules.bling.helpers.icon_theme')("Mint-Y", 48)

_M.menuforge = require 'yoru-menu.menu'

local function create_pinnned_menu(cname, exec, widget) 
   
      local ssh = _M.menuforge({
         _M.menuforge.button({
            icon = {icon = "", font = "Material Icons Round "},
            text = "Open Application", 
            on_press = function()
               Gio.AppInfo.launch_uris_async(Gio.AppInfo.create_from_commandline(exec, nil, 0))
               
            end
         }),
         
         _M.menuforge.button({
            icon = {icon = "", font = "Material Icons Round "},
            text = "Open App Settings", 
            on_press = function()

            end
         }),
         _M.menuforge.button({
            icon = {icon = "", font = "Material Icons Round "}, 
            text  = "Remove app from taskbar",
            on_press = function()
                _M.pinned_apps:remove_widgets(widget)                
                pinmanager.RemoveApp(cname)
               
            end
         }),
      })
      return ssh
   	
end

local function create_menu(c) 
   
      local ssh = _M.menuforge({
         _M.menuforge.button({
            icon = {icon = "", font = "Material Icons Round "},
            text = "Close Application", 
            on_press = function()
               c:kill()
               
            end
         }),
         
         _M.menuforge.button({
            icon = {icon = "", font = "Material Icons Round "},
            text = "Minimize/Unminimize Application", 
            on_press = function()
               c.minimized = not c.minimized
               
            end
         }),
         _M.menuforge.button({
            icon = {icon = "", font = "Material Icons Round "},
            text = "Open App Settings", 
            on_press = function()
               
            end
         }),
      })
   	return _M.menuforge({
         _M.menuforge.button({
            icon = {icon = "", font = "Material Icons Round "}, 
            text  = "Pin app to taskbar",
            on_press = function()
              
               pinmanager.AddApp(c.class, icon_helper:get_client_icon_path(c), true) 
               
            end
         }),

   
         _M.menuforge.sub_menu_button({
            icon = {icon = "", font = "Material Icons Round "},
            text = "Application", 
            sub_menu = ssh
         })
      })
end

function _M.pinned_template(icon) 
      return wibox.widget{
         widget = wibox.container.place, 
         valign = 'top',   
         {
            widget = wibox.container.margin,
            left = 0,
            right = 0,
            top = beautiful.dpi(1.2),
            bottom = beautiful.dpi(3.4),  
      
         {
            widget = wibox.container.background,
            
            forced_width = beautiful.dpi(30),
            forced_height = beautiful.dpi(30),
            shape = function(cr, w, h)
               gears.shape.rounded_rect(cr, w, h, 7)
               
            end,
            id = "bgdis",
            -- {
            --  widget = wibox.container.place,
            --  halign = 'center',
            --  valign = 'center',
               {
            
                  widget = wibox.widget.imagebox,
                  id = 'clienticon',
                  image = icon,
                  forced_height = beautiful.dpi(30),
                  forced_width = beautiful.dpi(30)
               }
            -- }
         }
         
      
      }}
   
end

function _M.create_tasklist(s)
   return awful.widget.tasklist {
    screen   = s,
    style = {
      
        
    },
    filter   = awful.widget.tasklist.filter.alltags,
    buttons  = {
      awful.button({}, 1, function(c)
        

         
      end)
    },
    layout   = {
      pacing_widget = {
            {
                forced_width  = beautiful.dpi(2.4),
                forced_height = beautiful.dpi(10),
                thickness     = 1,
                color         = '#777777',
                widget        = wibox.widget.separator
            },
            valign = 'center',
            halign = 'center',
            widget = wibox.container.place,
        },
        spacing = beautiful.dpi(7),
        layout  = wibox.layout.fixed.horizontal
    },
    widget_template = {
      -- background_role, clienticon, 
      
       {
         widget = wibox.container.place, 
         valign = 'top',   
      {
         widget = wibox.container.margin,
         left = 0,
         right = 0,
         top = beautiful.dpi(1.2),
         bottom = beautiful.dpi(3.4),  
      
         {
            widget = wibox.container.background,
            
            forced_width = beautiful.dpi(30),
            forced_height = beautiful.dpi(30),
            shape = function(cr, w, h)
               gears.shape.rounded_rect(cr, w, h, 7)
               
            end,
            id = "bgling",
            -- {
            --  widget = wibox.container.place,
            --  halign = 'center',
            --  valign = 'center',
               {
            
                  widget = wibox.widget.imagebox,
                  id = 'clienticon',
                  forced_height = beautiful.dpi(30),
                  forced_width = beautiful.dpi(30)
               }
            -- }
         }
         
      
      }},
   
      {
         widget = wibox.container.margin,
         left = 0,
         right = 0 ,
         bottom = 0,
         id = "eee",
   
         {
            
            wibox.widget.base.make_widget(),
            forced_height = beautiful.dpi(  2.4),
            forced_width = beautiful.dpi(35),
            
            id            = 'background_role',
            widget        = wibox.container.background,
         }
      },
      
        nil,
        create_callback = function(self, c, index, objects) --luacheck: no unused args
            
            self:buttons{
               awful.button({}, 3, function()
                  local l  = create_menu(c)
                  l:toggle({
                     wibox = s.wibox, 
                     offset = {y = -100}
                  })
                  
                  end
      
               ),
               awful.button({}, 1, function()
                   if not c.active then
                     c:activate {
                        context		= "task_bar",
                        switch_to_tag	= true,
                     }

         else 
            c.minimized = true

         end
               end)
            }
            self:get_children_by_id('clienticon')[1].image = icon_helper:get_client_icon_path(c) 
            
            
            self:connect_signal("mouse::enter", function()
               
               if not c.active then 
                  self:get_children_by_id("bgling")[1].bg = beautiful.transparent_bg
               else 
                  self:get_children_by_id("bgling")[1].bg = "#e64553ab"
               end 
            end)
            self:connect_signal("mouse::leave", function()
               self:get_children_by_id("bgling")[1].bg = ""
               
            end)
           
            -- BLING: Toggle the popup on hover and disable it off hover
            -- self:connect_signal('mouse::enter', function(ns)
            --         self:get_children_by_id('zombie')[1].bg = "#e5e9f0cc"  
            --         awesome.emit_signal("bling::task_preview::visibility", s,
            --                             true, c)
                              

            --     end)
            --     self:connect_signal('mouse::leave', function(ns)
            --         self:get_children_by_id('zombie')[1].bg = "#e5e9f066"
            --         awesome.emit_signal("bling::task_preview::visibility", s,
            --                             false, c)
                    
            --     end)
        end,
        layout = wibox.layout.align.vertical,
    },
}


end

_M.pinned_apps = wibox.layout{ layout = wibox.layout.flex.horizontal, spacing = beautiful.dpi(7)} 


function _M.create_wibox(s)
   local launcher = wibox.widget{
      widget = wibox.container.background, 
      -- bg = "#e5e9f066", 
      forced_width = beautiful.dpi(52),
      wibox.widget{
            widget = wibox.container.place,
            wibox.widget{
               widget = wibox.widget.imagebox, 
               -- resize = true,
               forced_height = beautiful.dpi(25),
               forced_width = beautiful.dpi(25),
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
         screen.emit_signal("toggle::launcher")
         -- awful.spawn("/home/arthex/.config/rofi/launchers/type-3/launcher.sh")

         
      end),
      awful.button({}, 3, function()
         naughty.notify({text = "This feature hasnt been implemented yet!"})
         
      end)
   }
   
    
   local wib =awful.wibar{
      screen = s,
      height = beautiful.dpi(40),
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
            spacing = 0,
            wibox.widget {
               widget = wibox.container.place, 
                  
                  _M.pinned_apps
               
            },
           
            wibox.widget{
              
               widget = wibox.container.place,
               s.tasklist, 
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
   awesome.connect_signal('pin::add', function(cname, icon, exec, d) 
      local p = _M.pinned_template(icon) 
   
      p:connect_signal('mouse::enter', function() 
         p:get_children_by_id('bgdis')[1].bg = beautiful.transparent_bg
      end)
      p:connect_signal('mouse::leave', function() 
         p:get_children_by_id('bgdis')[1].bg = ""   
      
      end) 
      
      
      p:buttons{
         awful.button({}, 1, function()
            Gio.AppInfo.launch_uris_async(Gio.AppInfo.create_from_commandline(exec, nil, 0))
         end),
         awful.button({}, 3, function()
            local pop = create_pinnned_menu(cname, exec, p)
            pop:toggle({
               wibox = wib, 
               offset = {y = - 200}
            })
         end)
      }
      if not d then 
         _M.pinned_apps:add(p)
      end
      client.connect_signal('manage', function(c)
         if c.class == nil then 
            return 
         end 
         if string.lower(c.class)  == string.lower(cname) then
            _M.pinned_apps:remove_widgets(p)
         end
         
      end)
      client.connect_signal('unmanage', function(c)
        local  n = false
         if string.lower(c.class) == nil then 
            return 
         end 
         if string.lower(c.class) == string.lower(cname) then
            naughty.notify({text = c.class, title = cname})
            for i, v in ipairs(client.get(s)) do 
               if string.lower(v.class) == string.lower(cname) then
                  n = true
               end
               
            end
            if not n then
               _M.pinned_apps:add(p)
            end
         end
         
      end)
   
   end)
   return wib
end

local drtv = require ('drth')
_M.launcher = require 'widgets.launcher'
_M.tagswitcher = require 'widgets.tagswitcher'
return _M

