local awful = require'awful'
local ruled = require'ruled'

ruled.client.connect_signal('request::rules', function()
   -- All clients will match this rule.
   ruled.client.append_rule{
      id         = 'global',
      rule       = {},
      properties = {
         focus     = awful.client.focus.filter,
         raise     = true,
         screen    = awful.screen.preferred,
         placement = awful.placement.no_overlap + awful.placement.no_offscreen,
         border_width = 2,
      }
   }

   -- Floating clients.
   ruled.client.append_rule{
      id = 'floating',
      rule_any = {
         instance = {'copyq', 'pinentry'},
         class = {
            'Arandr',
            'Blueman-manager',
            'Gpick',
            'Kruler',
            'Sxiv',
            'Tor Browser',
            'Wpa_gui',
            'veromix',
            'xtightvncviewer',
         },
         -- Note that the name property shown in xprop might be set slightly after creation of the client
         -- and the name shown there might not match defined rules here.
         name = {
            'Event Tester',  -- xev.
         },
         role = {
            'AlarmWindow',    -- Thunderbird's calendar.
            'ConfigManager',  -- Thunderbird's about:config.
            'pop-up',         -- e.g. Google Chrome's (detached) Developer Tools.
         }
      },
   

      properties = {floating = true}
   }

   -- Add titlebars to normal clients and dialogs
   ruled.client.append_rule{
      id         = 'titlebars',
      rule_any   = {type = {'normal', 'dialog'}},
      properties = {titlebars_enabled = true},
   }

   ruled.client.append_rule {
    rule = { class = "kitty" },
    properties = {
        border_width = 4,
        
    },
    
}
   ruled.client.append_rule {
      rule = { class = "plank"},
      properties = {
         forced_height = 200
      }
   }
   ruled.client.append_rule {
      rule = { instance = "clock"},
      properties = {
         type = "dock", 
         width = 400, 
         height = 250,
         x = 30, 
         y = 700,
         sticky = true,
         border_width = 3,
         below = true,
         floating = true,
      }
   }
   ruled.client.append_rule {
      rule = { instance = "starterm"},
      properties = {
         type = "dock", 
         floating = true,
         below = true,
         width = 400,
         border_width = 3,
         sticky = true,
         height = 80,
         x = 30,
         y = 968
      }
   }

   -- Set Firefox to always map on the tag named '2' on screen 1.
   -- ruled.client.append_rule {
   --    rule       = {class = 'Firefox'},
   --    properties = {screen = 1, tag = '2'}
   -- }
end)
