local lgi = require 'lgi'
local Gio = lgi.require('Gio', "2.0")
local naughty = require 'naughty'
local misc = require 'helpers.misc'
local json = require 'helpers.json'
local beautiful = require 'beautiful'
local IconThemeHelper = require('modules.bling.helpers.icon_theme')(beautiful.tasklist_icon_theme, beautiful.tasklist_icon_size)
local gears = require 'gears'
local beautiful = require 'beautiful'


--- Gets App Info
---@param client any
---@return table "{name, cname exec, icon, desktop_app_info}"
local function GetDesktopFile(client)
    local app_info = Gio.AppInfo
    local apps = app_info.get_all()
    local cname = string.lower(client.class)
    for _, app in ipairs(apps) do 
        local desktop_app_info = Gio.DesktopAppInfo.new(app_info.get_id(app))
        if misc.InString(string.lower(app_info.get_name(app)), cname) then
            return {
                name = app_info.get_name(app),  
                cname = client.class, 
                exec = Gio.DesktopAppInfo.get_string(desktop_app_info, "Exec"),
                icon = IconThemeHelper:get_client_icon_path(client),
                desktop_app_info = desktop_app_info
            }
        end
    end
end
--- Saves app to pinned_apps.json 
--- @param args any "{name,cname, exec, icon, desktop_app_info}"
local function SaveApp(args) 
    if not args then
        error("The app couldnt be matched with a existing .desktop file, exiting")
    end
    if json.ReadFile(beautiful.pinned_file_path or gears.filesystem.get_configuration_dir() .. "data/pinned.json")[args.cname] then
        error("App is Already Pinned, Remove it to Repin App")
    end

    json.DumpFile(beautiful.pinned_file_path or gears.filesystem.get_configuration_dir () .. "data/pinned.json", {
        [args.cname] = {
            name = args.name, 
            exec = args.exec, 
            icon = args.icon, 
        }
    })


 
end
--- Fetches and returns all current pinned_apps
--- @return table "Table containing Pinned apps" 
local function GetPinnedApps() 
    return json.ReadFile(beautiful.pinned_file_path or gears.filesystem.get_configuration_dir() .. "data/pinned.json")
    
end

local function CreateApp(client)
    local file = GetDesktopFile(client) 
    SaveApp(file) 

    awesome.emit_signal('pin::add', file)
    
end 

local function DeleteApp(cname)
    local cname = cname
    local _apps = {} 
    local _currentapps = GetPinnedApps() 
    for cnameapp, children in pairs(_currentapps) do
        if string.lower(cnameapp) == string.lower(cname) then
            
        else 
            table.insert(_apps, {
                [cname] = children 
            })
        end
            
    end
    json.ReplaceFileContent(beautiful.pinned_file_path or gears.filesystem.get_configuration_dir() .. "data/pinned.json", _apps)
end

local function UpdateTable(table, id) 
    local _widgets = {}
    for _, child in ipairs(table.children) do 
       
        if child:get_children_by_id(id)[1] then
            naughty.notify({text = ""})
        else 
            table.insert(_widgets, child)
        end
        
    end
   
    return _widgets
    
end
local function add_add_to_template(cname) 
         local add_app = false
         for i, v in ipairs(client.get(s)) do 
            if string.lower(v.class) == string.lower(cname) then
               add_app = true
            end
         end 
         return not add_app
        
      end
awesome.connect_signal('startup', function()
    local apps = GetPinnedApps() 
    for cname, children in pairs(apps) do 
        awesome.emit_signal('pin::add', {name = children.name, cname = cname, exec = children.exec,icon = children.icon})

    end 
    
end)

return {
    GetDesktopFile = GetDesktopFile,
    SaveApp = SaveApp, 
    GetPinnedApps = GetPinnedApps, 
    CreateApp = CreateApp, 
    DeleteApp = DeleteApp, 
    UpdateTable = UpdateTable,
    add_add_to_template = add_add_to_template
}
