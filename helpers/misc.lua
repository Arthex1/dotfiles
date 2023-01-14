local _M = {}
local gears = require 'gears'
function _M.TableToString(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. _M.TableToString(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

function _M.double_click_event_handler(double_click_event) 
   if double_click_timer then
      double_click_timer:stop()
      double_click_timer =  nil
      double_click_event()
      return  
   end
   double_click_timer = gears.timer.start_new(0.20, function()
      double_click_timer = nil 
      return false 
   end)

   
end

function _M.hex_to_rgb(color)
   if color == nil then
      return
   end
	color = color:gsub("#", "")
	return {
		r = tonumber("0x" .. color:sub(1, 2)),
		g = tonumber("0x" .. color:sub(3, 4)),
		b = tonumber("0x" .. color:sub(5, 6)),
		a = #color == 8 and tonumber("0x" .. color:sub(7, 8)) or 255,
	}
end
local function clip(num, min_num, max_num)
	return math.max(math.min(num, max_num), min_num)
end

-- Converts the given hex color

function _M.rgb_to_hex(color)
	local r = clip(color.r or color[1], 0, 255)
	local g = clip(color.g or color[2], 0, 255)
	local b = clip(color.b or color[3], 0, 255)
	local a = clip(color.a or color[4] or 255, 0, 255)
	return "#" .. string.format("%02x%02x%02x%02x", math.floor(r), math.floor(g), math.floor(b), math.floor(a))
end

function _M.InString(str, substr)
   return str:find(substr, 0, true)
end
   

return _M