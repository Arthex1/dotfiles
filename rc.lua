-- awesome_mode: api-level=5:screen=on
-- load luarocks if installed
pcall(require, 'luarocks.loader')

-- load theme

local beautiful = require'beautiful'
local gears = require'gears'
beautiful.init('/home/arthex/.config/awesome/theme.lua')

local titlebar = require 'nice' 
titlebar()

-- load key and mouse bindings
require'bindings'

-- load rules
require'rules'

-- load signals
require'signals' 

-- load autostart move 
require 'autostart'