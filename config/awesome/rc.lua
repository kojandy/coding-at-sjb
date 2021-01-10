pcall(require, "luarocks.loader")

local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")

beautiful.init({
    font = "Inter Bold 10",
    border_normal = "#ffffff",
    border_width = 1,
    useless_gap = 10,
    taglist_font = "Material Design Icons 12",
    taglist_bg_focus = "#187bcd",
    taglist_bg_urgent = "#c62121",
    tasklist_align = "center",
    tasklist_spacing = 2,
    tasklist_disable_icon = true,
    tasklist_bg_normal = "#000000",
    tasklist_bg_focus = "#187bcd",
    tasklist_bg_urgent = "#c62121",
    tasklist_bg_minimize = "#ffffff00",
    wibar_bg = "#ffffff00",
    wibar_height = 20,
    titlebar_bg = "#000000",
})

terminal = os.getenv("TERMINAL")

awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.floating,
}

awful.screen.connect_for_each_screen(function(s)
    -- web dev doc remote game 6 7 misc chat media
    awful.tag({ "\u{F059F}", "\u{F07B7}", "\u{F09A8}", "\u{F0318}", "\u{F1362}", "6", "7", "\u{F01D8}", "\u{F0B79}", "\u{F075A}" }, s, awful.layout.layouts[1])
    awful.wibar({ position = "top", screen = s }):setup {
        layout = wibox.layout.align.horizontal,
        expand = "none",
        awful.widget.taglist {
            screen  = s,
            filter  = awful.widget.taglist.filter.noempty,
        },
        wibox.widget.textclock("%a, %b %-d   %R"),
    }
    s.taskbar = awful.wibar({ position = "top", screen = s, visible = false })
    s.taskbar:setup {
        layout = wibox.layout.flex.horizontal,
        awful.widget.tasklist {
            screen  = s,
            filter  = awful.widget.tasklist.filter.currenttags,
        },
    }
end)

Mod = {"Mod4"}
Mod_S = {"Mod4", "Shift"}

globalkeys = gears.table.join(
    awful.key(Mod, "j", function() awful.client.focus.byidx(1) end),
    awful.key(Mod, "k", function() awful.client.focus.byidx(-1) end),
    awful.key(Mod_S, "j", function() awful.client.swap.byidx(1) end),
    awful.key(Mod_S, "k", function() awful.client.swap.byidx(-1) end),

    awful.key(Mod, "l", function() awful.tag.incmwfact(0.05) end),
    awful.key(Mod, "h", function() awful.tag.incmwfact(-0.05) end),
    awful.key(Mod_S, "h", function() awful.tag.incnmaster(1, nil, true) end),
    awful.key(Mod_S, "l", function() awful.tag.incnmaster(-1, nil, true) end),

    awful.key(Mod, "m", function()
        client.focus = awful.client.getmaster()
        if client.focus then
            client.focus:raise()
        end
    end),
    awful.key(Mod, "u", awful.client.urgent.jumpto),

    awful.key(Mod, "Tab", function() awful.tag.history.restore(awful.screen.focused(), "previous") end),
    awful.key({"Mod1"}, "Tab", function()
        awful.client.focus.history.previous()
        if client.focus then
            client.focus:raise()
        end
    end),

    awful.key(Mod, "Return", function() awful.spawn(terminal) end),
    awful.key(Mod_S, "w", function() awful.spawn("chromium-browser") end),
    awful.key(Mod_S, "f", function() awful.spawn("nemo") end),

    awful.key(Mod_S, "Escape", awesome.restart),
    awful.key(Mod, "grave", function() awful.layout.inc(1) end),

    awful.key(Mod_S, "BackSpace", function()
        local c = awful.client.restore()
        if c then
            c:emit_signal("request::activate", "key.unminimize", {raise = true})
        end
    end),

    awful.key(Mod, "slash", function()
        local s = awful.screen.focused()
        s.taskbar.visible = not s.taskbar.visible
    end),

    awful.key(Mod, "i", function() awful.spawn("amixer --quiet set Master 5%- unmute", false) end),
    awful.key(Mod, "o", function() awful.spawn("amixer --quiet set Master toggle", false) end),
    awful.key(Mod, "p", function() awful.spawn("amixer --quiet set Master 5%+ unmute", false) end),

    awful.key(Mod_S, "i", function() awful.spawn("playerctl previous", false) end),
    awful.key(Mod_S, "o", function() awful.spawn("playerctl play-pause", false) end),
    awful.key(Mod_S, "p", function() awful.spawn("playerctl next", false) end)
)

clientkeys = gears.table.join(
    awful.key(Mod, "q", function(c)
        if not c.floating and c.first_tag.layout.name ~= "floating" then
            if awful.client.next(1) == awful.client.getmaster() then
                awful.client.focus.byidx(-1)
            else
                awful.client.focus.byidx(1)
            end
        end
        c:kill()
    end),
    awful.key(Mod, "s", awful.client.floating.toggle),
    awful.key(Mod, "f", function(c)
        c.fullscreen = not c.fullscreen
        c:raise()
    end),
    awful.key(Mod, "z", function(c)
        c.maximized_vertical = not c.maximized_vertical
        c:raise()
    end),
    awful.key(Mod_S, "z", function(c)
        c.maximized = not c.maximized
        c:raise()
    end),
    awful.key(Mod, "semicolon", function(c) c:swap(awful.client.getmaster()) end),
    awful.key(Mod, "BackSpace", function(c) c.minimized = true end)
)
for i = 1, 10 do
    globalkeys = gears.table.join(globalkeys,
        awful.key(Mod, "#" .. i + 9, function()
            local screen = awful.screen.focused()
            local tag = screen.tags[i]
            if tag then
                tag:view_only()
            end
        end),
        awful.key(Mod_S, "#" .. i + 9, function()
            if client.focus then
                local tag = client.focus.screen.tags[i]
                if tag then
                    client.focus:move_to_tag(tag)
                end
            end
        end),
        awful.key({"Mod4", "Control"}, "#" .. i + 9, function()
            local screen = awful.screen.focused()
            local tag = screen.tags[i]
            if tag then
                awful.tag.viewtoggle(tag)
            end
        end),
        awful.key({"Mod4", "Control", "Shift"}, "#" .. i + 9, function()
            if client.focus then
                local tag = client.focus.screen.tags[i]
                if tag then
                    client.focus:toggle_tag(tag)
                end
            end
        end)
    )
end

root.keys(globalkeys)

awful.rules.rules = {
    {
        rule = {},
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = gears.table.join(
                awful.button({}, 1, function(c)
                    c:emit_signal("request::activate", "mouse_click", {raise = true})
                end),
                awful.button(Mod, 1, function(c)
                    c:emit_signal("request::activate", "mouse_click", {raise = true})
                    if c.first_tag.layout.name ~= "floating" then
                        c.floating = true
                    end
                    awful.mouse.client.move(c)
                end),
                awful.button(Mod, 2, function(c)
                    c:kill()
                end),
                awful.button(Mod, 3, function(c)
                    c:emit_signal("request::activate", "mouse_click", {raise = true})
                    awful.mouse.client.resize(c)
                end)
            ),
            screen = awful.screen.preferred,
            placement = awful.placement.centered + awful.placement.no_offscreen
        }
    },
    {
        rule_any = {
            class = {"Nemo"},
        },
        properties = {floating = true},
    },
}

client.connect_signal("manage", function (c)
    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        awful.placement.no_offscreen(c)
    end

    if not awesome.startup then
        awful.client.setslave(c)
        local prev_focused = awful.client.focus.history.get(awful.screen.focused(), 1, nil)
        local prev_c = awful.client.next(-1, c)
        if prev_c and prev_focused then
            while prev_c ~= prev_focused do
                c:swap(prev_c)
                prev_c = awful.client.next(-1, c)
            end
        end
    end

    c.shape = function(cr, w, h)
        gears.shape.rounded_rect(cr, w, h, 5)
    end
end)

client.connect_signal("request::titlebars", function(c)
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 2, function()
            c:kill()
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c, {size = 24}) : setup {
        {
            align = "center",
            widget = awful.titlebar.widget.titlewidget(c),
        },
        layout = wibox.layout.flex.horizontal,
        buttons = buttons,
    }
end)

client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("manage", function(c)
    if c.floating or c.first_tag.layout.name == "floating" then
        awful.titlebar.show(c)
    else
        awful.titlebar.hide(c)
    end
end)

client.connect_signal("property::floating", function(c)
    if c.floating and not c.requests_no_titlebar then
        awful.titlebar.show(c)
    else
        awful.titlebar.hide(c)
    end
end)

tag.connect_signal("property::layout", function(t)
    local clients = t:clients()
    for k,c in pairs(clients) do
        if c.floating or c.first_tag.layout.name == "floating" then
            awful.titlebar.show(c)
        else
            awful.titlebar.hide(c)
        end
    end
end)

awful.spawn("picom -b", false)
