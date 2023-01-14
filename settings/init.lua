local _M = {} 
local helpers = require 'helpers'
local gears = require 'gears'
local beautiful = require 'beautiful'
local vars = require 'config.vars'
local naughty = require 'naughty'
local rubato = require 'rubato'
local awful = require 'awful'
local wibox = require 'wibox'

-- Wallpaper 

-- No comment on this one
-- @returns nil
local function GetWallpaper() 
    local content = helpers.json.ReadFile(
        beautiful.settings_file_path or gears.filesystem.get_configuration_dir() .. "data/settings.json"
    )
    
    if content["wallpaper"] ~= nil then
        return content["wallpaper"]
    else 
        return nil
    end
end
-- No comment on this one, really cool though, overrides current wallpaper.
-- @param wallpaper filepath 
-- @returns nil
local function SetWallpaper(wallpaper)
    if not helpers.json.FileExists(wallpaper) then
        error("File does not exist")
    end 
    helpers.json.DumpFile(
        beautiful.settings_file_path or gears.filesystem.get_configuration_dir() .. "data/settings.json",
        {
            ["wallpaper"] = wallpaper
        }

    )
    
end
local function UpdateWallpaper()
    for s in screen do
        screen.emit_signal('request::wallpaper', s)
    end
    
end


awesome.connect_signal('set::wallpaper', function(wallpaper) 
    SetWallpaper(wallpaper) 
    local wallpaper = GetWallpaper()
    if wallpaper ~= nil then
        beautiful.wallpaper = wallpaper
        UpdateWallpaper()
    else
        beautiful.wallpaper = vars.wallpapers["astro"]
        UpdateWallpaper()
        naughty.notify({text = tostring("The wallpaper couldnt be changed for some reason... Defaulting to normal wallpaper")})
    end


end)

-- Theme 
--    s.promptbox = widgets.create_promptbox()
--    s.layoutbox = widgets.create_layoutbox(s)
--    s.taglist   = widgets.create_taglist(s)
--    s.tasklist  = widgets.create_tasklist(s)
--    s.wibox     = widgets.create_wibox(s)

local function GetTheme() 
    local content = helpers.json.ReadFile(
        beautiful.settings_file_path or gears.filesystem.get_configuration_dir() .. "data/settings.json"
    )
    
    if content["theme"] ~= nil then
        return content["theme"]
    else 
        return nil
    end
end
-- No comment on this one, really cool though, overrides current wallpaper.
-- @param theme ["dark", "light"]
-- @returns nil
local function SetTheme(theme)
    if string.lower(theme) == 'dark' then
        theme = 'dark'
    elseif string.lower(theme) == 'light' then 
        theme = 'light'
    else 
        error('Invalid theme passed', tostring(theme))
        return
    end 
    helpers.json.DumpFile(
        beautiful.settings_file_path or gears.filesystem.get_configuration_dir() .. "data/settings.json",
        {
            ["theme"] = theme
        }

    )
    
end
local function UpdateTheme(theme)
    if string.lower(theme) == 'dark' then
        theme = 'dark'
    elseif string.lower(theme) == 'light' then 
        theme = 'light'
    else 
        error('Invalid theme passed', tostring(theme))
        return
    end 
    awesome.emit_signal('update::theme', theme)
    
end

awesome.connect_signal('set::theme', function(theme) 
        SetTheme(theme)
        local STheme = GetTheme() 
        if STheme ~= nil then
            UpdateTheme(theme)
        else
            UpdateTheme('dark')
            naughty.notify({text = 'Themed couldnt be changed for some reason.. Defaulting to default theme'})
        end
    
    
        
end) 

-- Loading on Startup 
awesome.connect_signal('startup', function() 
    local wallpaper = GetWallpaper()
    -- print('New Session Starting')
    
    if wallpaper ~= nil then
        beautiful.wallpaper = wallpaper
        
        UpdateWallpaper()
    else
        beautiful.wallpaper = vars.wallpapers["astro"]
        
        UpdateWallpaper()
    end
    local theme = GetTheme() 
    if theme ~= nil then
        UpdateTheme(theme)
    else 
        UpdateTheme('dark')
    end


    
end)

-- Widget position 

