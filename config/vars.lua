local _M = {}

local awful = require'awful'
local mods = require("modules")

_M.layouts = {
   awful.layout.suit.floating,
   awful.layout.suit.tile,
   awful.layout.suit.tile.left,
   awful.layout.suit.tile.bottom,
   awful.layout.suit.tile.top,
   awful.layout.suit.max,
   awful.layout.suit.max.fullscreen,

}

_M.tags = {'1', '2', '3', '4', '5', '6', '7', '8', '9'} 

return _M
