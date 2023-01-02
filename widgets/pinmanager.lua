local  Gio = require 'lgi'.Gio
local naughty = require 'naughty'

local helpers = require 'beautiful'.helpers
local function Get_App(cname)
    all_apps = Gio.AppInfo.get_all()


    do
        for _, app in pairs(all_apps) do 
            

            if helpers.instring(string.lower(app:get_locale_string("Name")), string.lower(cname)) then
                return app:get_locale_string("Name"), app:get_locale_string("Exec") 
            end
        end
    end


end 


local function SaveApp(cname, icon, exec, id) 
    
    if not cname or not icon or not exec then
        error("Missing a argument on SaveApp") 
        return
    end
    if helpers.ReadJsonFile('/home/arthex/.config/awesome/widgets/apps.json')[cname] then
        return naughty.notify({text = cname .. "already exists!"})
        
    end
    helpers.DumpJsonFile('/home/arthex/.config/awesome/widgets/apps.json', {
        [cname] = {
            ["icon"] = icon, 
            ["exec"] = exec, 
        }
    })
    
end

local function AddApp(cname, icon, dontemitsignal)
    
    local app, cmd = Get_App(cname) 
    if not app or not cmd then
        naughty.notify({text = cname .. "not found!"}) 
        
        return 
    end
    SaveApp(cname, icon, cmd)
    --  
    awesome.emit_signal('pin::add', cname, icon, cmd, dontemitsignal) 
    
   
end
local function RemoveApp(cname)
    local s = helpers.ReadJsonFile('/home/arthex/.config/awesome/widgets/apps.json')
    local t = {}
    for k, v in pairs(s) do
        
        if string.lower(cname) == string.lower(k) then
            
        else
            t[k] = v
        end
    end
   
    helpers.ROJF('/home/arthex/.config/awesome/widgets/apps.json', t)
end
awesome.connect_signal('startup', function() 
    local s = helpers.ReadJsonFile('/home/arthex/.config/awesome/widgets/apps.json') 
    for k, v in pairs(s) do
        local n = false 
        for i, v in ipairs(client.get()) do 
            if string.lower(v.class) == string.lower(k) then
                  n = true
            end
               
        end
        if not n then 
            awesome.emit_signal('pin::add', k, v["icon"], v["exec"])
        end
    end

    
end)

return {
    AddApp = AddApp,
    RemoveApp = RemoveApp
}
