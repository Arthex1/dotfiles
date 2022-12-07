local _M = {}
local wibox = require("wibox" )

_M.apps = {
    [1] = {
        label = "LMFAO",
        type = "file",
        image = "/home/arthex/.config/awesome/icons/arch.png",
        onclick = "open /home/arthex/.config/awesome/icons/arch.png",
    },
    
}
function _M.render_all(args)
    local apps = args.apps or _M.apps 
    local iconsize = args.iconsize or 15
    local labelfont = args.labelfont or "bold"
    for k, v in pairs(apps) do
        _M.render_one(v, iconsize, labelfont)
        
    end
end

function _M.render_one(app, iconsize, labelfont) 
    local icon = app.image or "/home/arthex/.config/awesome/icons/arch.png"
    local iconsize = iconsize
    local labelfont = labelfont
    local onclick = app.onclick or "nothing" 

    local wi = wibox{
        bg = "#00000000",
        visible = true,
        height = iconsize,
        width = iconsize, 
    }
    local img = wibox.widget{
        widget = wibox.widget.imagebox,
        image = icon,
        forced_width = iconsize,
        forced_height = iconsize
    }
    wi:setup{
        layout = wibox.layout.flex.horziontal,
        img 
    }
    
end

_M.render_all({})

return _M