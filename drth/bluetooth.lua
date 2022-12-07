
local awful = require("awful") 
local naughty = require("naughty")
local helpers = require("drth.helpers") 


local function get_all_connections()
    local connections = {}
    awful.spawn.easy_async_with_shell('bluetoothctl devices', function(output)
        local sr = {}
        local cp = helpers.split(output, "\n")
        local data = {} 
        for i, v in ipairs(cp) do
            if helpers.instring(v, "Device") then
                table.insert(sr, v)
            
            end
            
        end
        
        for i, v in ipairs(sr) do
            ls = helpers.split(v)
            local n = ""
            for i, v in ipairs(ls) do 
                if i >= 3 then
                    n = n .. " ".. v
                end
            end 
            table.insert(data, {name = n, devid = ls[2]}) 
     
        end
        connections = data 


    end)
    naughty.notify({text = helpers.len(connections)})
    return connections
    
    
    
end

return {
    get_all_connections = get_all_connections
}
