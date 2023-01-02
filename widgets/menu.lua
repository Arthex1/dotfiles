-- Credit goes to yoru by rhxyn 


local awful = require("awful")
local menu = require("yoru-menu.menu")
local hotkeys_popup = require("awful.hotkeys_popup")

local focused = awful.screen.focused()

--- Beautiful right-click menu
--- ~~~~~~~~~~~~~~~~~~~~~~~~~~

local instance = nil

local function awesome_menu()
	return menu({
		menu.button({
			icon = { icon = "", font = "Material Icons Round " },
			text = "Show Help",
			on_press = function()
				hotkeys_popup.show_help(nil, awful.screen.focused())
			end,
		}),
		menu.button({
			icon = { icon = "", font = "Material Icons Round " },
			text = "Manual",
			on_press = function()
				awful.spawn("kitty" .. " -e man awesome")
			end,
		}),
		menu.button({
			icon = { icon = "", font = "Material Icons Round " },
			text = "Edit Config",
			on_press = function()
				awful.spawn("code".. " " .. awesome.conffile)
			end,
		}),
		menu.button({
			icon = { icon = "", font = "Material Icons Round " },
			text = "Restart",
			on_press = function()
				awesome.restart()
			end,
		}),
		menu.button({
			icon = { icon = "", font = "Material Icons Round " },
			text = "Quit",
			on_press = function()
				awesome.quit()
			end,
		}),
	})
end

local function widget()
	return menu({
		menu.button({
			icon = { icon = "", font = "Material Icons Round " },
			text = "Applications",
			on_press = function()
				awful.spawn("notify-send not", false)
			end,
		}),
		menu.button({
			icon = { icon = "", font = "Material Icons Round " },
			text = "Terminal",
			on_press = function()
				awful.spawn("kitty", false)
			end,
		}),
		menu.button({
			icon = { icon = "", font = "Material Icons Round " },
			text = "Web Browser",
			on_press = function()
				awful.spawn("firefox", false)
			end,
		}),
		menu.button({
			icon = { icon = "", font = "Material Icons Round " },
			text = "File Manager",
			on_press = function()
				awful.spawn("", false)
			end,
		}),
		menu.button({
			icon = { icon = "", font = "Material Icons Round " },
			text = "Text Editor",
			on_press = function()
				awful.spawn("code", false)
			end,
		}),
		menu.separator(),
		menu.button({
			icon = { icon = "", font = "Material Icons Round " },
			text = "Exit",
			on_press = function()
				awesome.emit_signal("module::exit_screen:show")
			end,
		}),
		menu.sub_menu_button({
			icon = { icon = "", font = "Material Icons Round " },
			text = "AwesomeWM",
			sub_menu = awesome_menu(),
		}),
	})
end



if not instance then
	instance = widget() 
end
return instance
