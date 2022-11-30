-- awesome_mode: api-level=4:screen=on
-- awesome_mode: api-level=5:screen=on
-- load luarocks if installed
pcall(require, 'luarocks.loader')

-- load theme
local beautiful = require'beautiful'
local gears = require'gears'
local awful = require 'awful'
beautiful.init("/home/arthex/.config/awesome/theme/theme.lua")

-- load key and mouse bindings
require'bindings'
local os = require 'os'
-- load rules
require'rules'

-- load signals
require'signals'

require 'autostart.init'.init()
    -- awful.spawn("kitty", {tag = i})
 