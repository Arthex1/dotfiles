-- awesome_mode: api-level=5:screen=on
-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")
-- Standard awesome library

-- g
local rubato = require("rubato")

local gears = require("gears")
local awful = require("awful")
-- local rubato = require "rubato"
-- local rubato = require "rubato"
-- -- g
-- local rubato = require("rubato.beautiful")

require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
local os = require("os")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

local function make_fa_icon( code )
  return wibox.widget {
    image  = "~/Downloads/bluetooth.png",
    widget = wibox.widget.imagebox
}
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")
beautiful.notification_bg = "#2e3440"
beautiful.notification_fg = "#d8dee9"
beautiful.notification_border_color = "#2e3440"
beautiful.notification_border_width = 0.8
beautiful.notification_shape = gears.shape.rounded_rect
-- beautiful.notification_width = 200
-- beautiful.notification_height = 50
beautiful.notification_icon_size = 5

-- This is used later as the default terminal and editor to run.
terminal = "kitty" 
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor
update_cmd = "kitty --title='fly_is_kitty' --hold paru && notify-send 'The system has been updated'"
-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = { 
    awful.layout.suit.tile,
    awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
} 
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "Hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "Manual", terminal .. " -e man awesome" },
   {  "Edit config", editor_cmd .. " " .. awesome.conffile },
   { "Restart", awesome.restart },
   { "Update", function() awful.spawn(update_cmd) end },
   { "Quit", function() awesome.quit() end },
}



beautiful.menu_height=30
beautiful.menu_widht=120
-- beautiful.menu_submenu_icon = "/home/arthex/.config/awesome/icons/submenu.png" 
beautiful.menu_bg_normal="#23272a"
beautiful.menu_fg_normal="#eceff4"
beautiful.menu_fg_focus="#eceff4"

--beautiful.menu_bg_normal="051a39"
--beautiful.menu_bg_focus="051a39"
-- beautiful.menu_fg_normal="ff555"
-- beautiful.menu_fg_focus="ff555"
mymainmenu = awful.menu({ items = { { "Awesome", myawesomemenu},
                                    { "Terminal", terminal },
				    { "Browser", "firefox" }, 
				    { "Files", "thunar"} 
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })
function wibar_shape(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, 20)
    
end
beautiful.wibar_ontop = true 
local wb = wibox{ type="dock", visible=true, bg="#1d1f2470", x = "840", y="1000", position = "bottom", width = 280, height=90, ontop=true, opacity=0.6, shape = wibar_shape, drawable=true, input_passthrough=true }
function toggle_bar_on()
    -- timed = rubato.timed {
    -- duration = 1/2, --half a second
    -- intro = 1/6, --one third of duration
    -- override_dt = true, --better accuracy for testing
    -- subscribed = function(pos) print(pos) end
    -- }
    sleep(0.3)
    wb.opacity = 1
     
end

function sleep(seconds)
    os.execute("sleep " .. tostring(seconds))
    
end

function toggle_bar_off()
    sleep(0.5) 
    wb.opacity = 0
    
end
wb:connect_signal("mouse::leave", toggle_bar_off)
wb:connect_signal("mouse::enter", toggle_bar_on)
-- wb:connect_signal("mouse::leave", toggle_bar_off)
-- wb:connect_signal("mouse::enter", toggle_bar_on)
local firefox_icon =    wibox.widget {
    
        image =  "/home/arthex/.config/awesome/icons/firefox-logo.png", 
        -- resize = true, 
        forced_height = 55,
        forced_width  = 50,
        widget = wibox.widget.imagebox,
        opacity = 1,


    }
function spawn_firefox ()
    
    local x = os.execute("sleep 0.5 && wmctrl -a Mozilla Firefox")
end
firefox_icon:connect_signal("mouse::press", spawn_firefox)
function firefox_increase()
    sleep(0.05)
    fn = naughty.notify({text = "Firefox", ontop = true, position = "bottom_middle", shape = gears.shape.rounded_rect, opacity = 1, replaces_id = 5, margin = 10})
    firefox_icon.forced_height = 60
    firefox_icon.forced_width = 55
    
end
function firefox_decrease()
    sleep(0.05)
    
    naughty.destroy(fn, reason, false)
    firefox_icon.forced_height = 50
    firefox_icon.forced_width = 50
    
end
firefox_icon:connect_signal("mouse::enter", firefox_increase)
firefox_icon:connect_signal("mouse::leave", firefox_decrease)
local code_icon =    wibox.widget {
 
        image =  "/home/arthex/.config/awesome/icons/code.png", 
        -- resize = true, 
        forced_height = 55,
        forced_width  = 50,
        widget = wibox.widget.imagebox,
        opacity = 1,


    }
function code_increase()
    sleep(0.05)
    cn = naughty.notify({text = "Vscode", ontop = true, position = "bottom_middle", shape = gears.shape.rounded_rect, opacity = 1, replaces_id = 5, margin=10})
    code_icon.forced_height = 60
    code_icon.forced_width = 55
    
end
function code_decrease()
    sleep(0.05)
    naughty.destroy(cn, reason, false)
    code_icon.forced_height = 50
    code_icon.forced_width = 50
    
end
code_icon:connect_signal("mouse::enter", code_increase)
code_icon:connect_signal("mouse::leave", code_decrease)
local kitty_icon =    wibox.widget {

        image =  "/home/arthex/.config/awesome/icons/term.png", 
        -- resize = true, 
        forced_height = 55,
        forced_width  = 50,
        widget = wibox.widget.imagebox,
        opacity = 1,


    }
function kitty_increase()
    kn = naughty.notify({text = "Terminal", ontop = true, position = "bottom_middle", shape = gears.shape.rounded_rect, opacity = 1, replaces_id = 5, margin = 10})
    sleep(0.05)
    kitty_icon.forced_height = 60
    kitty_icon.forced_width = 55
    
end
function kitty_decrease()
    sleep(0.05)
    naughty.destroy(kn, "f", false)
    kitty_icon.forced_height = 50
    kitty_icon.forced_width = 50
    
end
kitty_icon:connect_signal("mouse::enter", kitty_increase)
kitty_icon:connect_signal("mouse::leave", kitty_decrease)
function start_firefox()
    awful.spawn("wmctrl -a firefox") 

    
end

firefox_icon:connect_signal("mouse::press", start_firefox)
wb:setup {
     spacing = -70,
     layout = wibox.layout.flex.horizontal,
        {
            widget = wibox.container.place,
            valign = "center",
            halign = "center",
            fill_horizontal = true, 
            -- firefox_icon,
            code_icon,
            spacing = 10
        },
                {
            widget = wibox.container.place,
            valign = "center",
            halign = "center",
            fill_horizontal = true, 
            -- firefox_icon,
            kitty_icon,
            spacing = 10
        },                {
            widget = wibox.container.place,
            valign = "center",
            halign = "center",
            fill_horizontal = true, 
            -- firefox_icon,
            firefox_icon,
            spacing = 10
        },


}


-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock()

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
                    
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )

local tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  c:emit_signal(
                                                      "request::activate",
                                                      "tasklist",
                                                      {raise = true}
                                                  )
                                              end
                                          end),
                     awful.button({ }, 3, function()
                                              awful.menu.client_list({ theme = { width = 250 } })
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-2)
                                          end))
beautiful.wallpaper = "/home/arthex/Downloads/nord_theme_wallpaper_by_thisahami_df78ber-fullview.jpg"
local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons
    }

    -- Create the wibox
    -- s.mywibox = awful.wibar({ position = "top", screen = s })

    -- Add widgets to the wibox
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}
naughty.config.padding = 34
naughty.config.icon_dirs = {"~/Downloads"} 
naughty.config.icon_formats = {"png", "jpg"}
naughty.config.spacing = 5.7


local function inString(s, substring)
  return s:find(substring, 1, true)
end


function wifi_check()
    local handle = io.popen("nmcli dev status | grep wlan0") 
    local result = handle:read("*a")
    handle:close()
    if (inString(result, "connected")) then
        return false 
    end


    
    return true
end

function bluetooth_check()
    local handle = io.popen("nmcli dev status | grep bt") 
    local result = handle:read("*a")
    handle:close()
    if (inString(result, "connected")) then
        return false 
    end


    
    return true
end


-- beautiful.menu_submenu_icon = ""

function bw_check()
    if (bluetooth_check) then 
        naughty.notify({ title = "Bluetooth Not Connected!", text = "You are not connected to a Bluetooth Device!", timeout = 7, position="bottom_right", icon="/home/arthex/Downloads/bluetooth.png", width=250, height=65, icon_size=45, opacity=0.8, callback=bluetooth_check })
    end 
    if (wifi_check()) then
        naughty.notify({ title = "‎WIFI Not Connected!", text = "You are not connected to a Wifi Connection!", timeout = 7, position="bottom_right", icon="/home/arthex/Downloads/wifi3.png", width=250, height=65, icon_size=18, opacity=0.8, callback=wifi_check })
    end 
end
local picture = wibox.widget {
    image = "/home/arthex/.config/awesome/icons/code.png",
    halign = 'center',
    forced_width = 335,
    forced_height = 70,
    horizontal_fit_policy = 'fit',
    vertical_fit_policy = 'fit',
    valign = 'center',
    clip_shape = wibar_shape,
    widget = wibox.widget.imagebox,
}
local music_player = wibox.widget {
    {
        layout = wibox.layout.flex.vertical, 
        valign = "top", 
        halign = "center",
        picture,
    },
    shape = wibar_shape, 
    bg = "#3b42527d",
    widget = wibox.widget.backgroun,
    --  margin = 3


}


function popup()
    local pop = wibox{type = "dock", visible=true, bg = "#1d1f24a6", x = "1530", y = "73", height = 380, width = 370, ontop=true, shape = wibar_shape, }
    pop:setup {
        layout = wibox.layout.flex.vertical, 
        spacing = 10, 
        {
            widget = wibox.container.place,
            valign = "bottom",
            halign = "center",
            fill_horizontal = true, 
            -- firefox_icon,
            music_player,
            spacing = 10,
            
        },
        
        
    
    }   


end

-- {{{ Key bindings
globalkeys = gears.table.join(
    awful.key({ modkey,           }, "u", bw_check,
              {description="Bluetooth & Wifi Connection Check", group="awesome"}),
    awful.key({ modkey,           }, "c", popup,
              {description="Bluetooth & Wifi Connection Check", group="awesome"}),
    awful.key({ modkey,           }, "h",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
 --   awful.key({ modkey,           }, "k",
 --       function ()
--            awful.client.focus.byidx(-1)
--        end
--        {description = "focus previous by index", group = "client"}), 
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),
       

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ modkey, "Enter" }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:emit_signal(
                        "request::activate", "key.unminimize", {raise = true}
                    )
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Prompt
    awful.key({ modkey },            "r",     function () awful.spawn("/home/arthex/.config/rofi/launchers/type-3/launcher.sh") end,
              {description = "run prompt", group = "launcher"}),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),
    -- Menubar
    awful.key({ modkey }, "p", function() awful.spawn("/home/arthex/.config/rofi/launchers/type-3/launcher.sh") end,
              {description = "show the menubar", group = "launcher"})
)

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey }, "q",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "s",
        function (c)
            c.maximized = not c.maximized
            c:raise() 
        end ,
        {description = "(un)maximize", group = "client"}),
    awful.key({ modkey, "d" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ "Control" }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { 
                     border_width = 1.6,
                     border_color = "#4c566a",
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },
    
    { rule = { name = "plank" },
      properties = {
      type="dock",
      border_width = 0,
      floating = true,
      sticky = true,
      ontop = true,
      focusable = false,
      below = false
    },
    },
    { rule = { name = "polybar" },
      properties = {
      type="dock",
      border_width = 0.5,
      ontop = true,
      focusable = false,
      below = false
    }},
    { rule = { name = "kitty"},
        properties = {
            border_width = 4.3,
            border_color = "#88c0d0"

        }
    },
    { rule = { name = "firefox"},
        properties = {
            border_width = 4.3,
            border_color = "#88c0d0"

        }
    },


    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {
          "Arandr",
          "Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "xtightvncviewer"},

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = false }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)


-- Custom Config -- 
beautiful.useless_gap=15
-- awful.spawn.with_shell("nitrogen --restore")
awful.spawn.with_shell("picom --experimental-backends --config ~/Documents/p.conf -b") 
awful.spawn.with_shell("~/.config/polybar/launch.sh")
awful.spawn.with_shell("feh --bg-scale ~/Downloads/nord_theme_wallpaper_by_thisahami_df78ber-fullview.jpg")

function display_check()
    local handle = io.popen("xrandr --listactivemonitors | grep HDMI1") 
    local result = handle:read("*a")
    handle:close()
    if (inString(result, "HDMI1")) then
        return true  
    end

    
    return false 
end


local function close_display()
    if display_check() then
        awful.spawn.with_shell("xrandr --output eDP1 --off && feh --bg-scale /home/arthex/Downloads/nord_theme_wallpaper_by_thisahami_df78ber-fullview.jpg")
    end
    return 
    
end

bw_check()
close_display()


-- print(rubato)

-- awful.spawn.with_shell("plank --preferences")
-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("manage", function (c)	
    c.shape = function(cr,w,h)
        gears.shape.rounded_rect(cr,w,h,25)
    end
end)
client.connect_signal("focus", function(c) c.border_color = "#88c0d0" end)
client.connect_signal("unfocus", function(c) c.border_color = "#88c0d0" end)
-- }}}
