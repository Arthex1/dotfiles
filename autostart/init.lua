local awful = require 'awful'
local naughty = require 'naughty'
local commands = {
    "bash /home/arthex/.config/awesome/scripts/kill_picom.sh",

}

function start()
    for i, v in ipairs(commands) do
        awful.spawn.with_shell(v)

        
    end
end

start() 