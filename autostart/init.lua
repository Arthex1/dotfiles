local awful = require 'awful'
local os = require 'os'
local _M = {}
local naughty = require 'naughty'
function start_command(command, shell)
    if shell then
        return awful.spawn.with_shell(command) 
    end
    awful.spawn(command)   
end



commands = {
    ["bash /home/arthex/p.sh"] = true, 
    -- ["killall kitty"] = true, 
     
    ["kitty --class clock -e tty-clock"] = true, 
    ["kitty --class starterm -e bash"] = true, 
    ["picom --config /home/arthex/Documents/p.conf -b"] = true 
}

local function inString(s, substring)
  return s:find(substring, 1, true)
end

function _M.init()
    
    for k, v in pairs(commands) do
        start_command(k, v)
             

    end
     
end


return _M
