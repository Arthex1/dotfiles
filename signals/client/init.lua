local awful = require'awful'
require'awful.autofocus'
local wibox = require'wibox'
local gears = require 'gears'
local naughty = require 'naughty'

client.connect_signal('mouse::enter', function(c)
   c:activate{context = 'mouse_enter', raise = false}
end)



-- client.connect_signal("manage", function(c)
   
--    c.shape = function(cr, w, h)
--       gears.shape.rounded_rect(cr, w, h, 9)
      
--    end 
   
-- end)
