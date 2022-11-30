local upower_widget = require("modules.awesome-battery_widget")
local battery_listener = upower_widget {
    device_path = '/org/freedesktop/UPower/devices/battery_BAT0',
    instant_update = true
}

battery_listener:connect_signal("upower::update", function(_, device)
    naughty.notify({text = tostring(device.percentage)})
    awesome.emit_signal("signal::battery", math.floor(device.percentage), device.state)
end)