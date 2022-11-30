
local bling = require("modules.bling")

local playerctl = {}
local instance = nil
local naughty = require 'naughty'

local function new()
	return bling.signal.playerctl.lib({
		update_on_activity = true,
		player = { "spotify"},
		debounce_delay = 0.1,
		interval = 0.1, 
	})
end

if not instance then
	instance = new()
end

instance:connect_signal("metadata", function(_, title, artist, album_path, album, new, player_name)
	if new == true then
		naughty.notify({
			app_name = "Music",
			title = title,
			text = artist .. "Awesome",
			image = album_path,
		})
	end
end)
return instance