--
--             へ  ♡
--         ૮ >  <)
--         / ⁻ ៸|         Key Bindings configurations
--      乀(ˍ,ل ل
--
-- ---------------------------------------------------------------------------------
--
-- Key bindings configurations
-- See https://wiki.hypr.land/Configuring/Binds/
--
-- programs.lua must be loaded before this module (terminal, fileManager, menu globals)
--

local mainMod = "SUPER"

-- Core window management
hl.bind(mainMod .. " + Q",           hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + C",           hl.dsp.window.close())
hl.bind(mainMod .. " + M",           hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch exit"))
hl.bind(mainMod .. " + X",            hl.dsp.exec_cmd(os.getenv("HOME") .. "/.config/hypr/scripts/powermenu.sh"))
hl.bind(mainMod .. " + E",           hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + SHIFT + F",   hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + R",           hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + SHIFT + R",   hl.dsp.exec_cmd("rofi -show emoji -modi emoji -emoji-format '{emoji}'"))
hl.bind(mainMod .. " + P",           hl.dsp.window.pseudo())
-- togglesplit removed in Hyprland 0.54+ and not applicable to scrolling layout
hl.bind(mainMod .. " + F",           hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + L",           hl.dsp.exec_cmd("hyprlock"))

-- Alt+Tab window switcher
hl.bind("ALT + Tab",                 hl.dsp.exec_cmd("snappy-switcher next"))
hl.bind("ALT + SHIFT + Tab",         hl.dsp.exec_cmd("snappy-switcher prev"))

-- Scrolling layout column navigation
hl.bind(mainMod .. " + left",        hl.dsp.layout("move -col"))
hl.bind(mainMod .. " + right",       hl.dsp.layout("move +col"))
hl.bind(mainMod .. " + period",      hl.dsp.layout("move +col"))
hl.bind(mainMod .. " + comma",       hl.dsp.layout("move -col"))

-- Switch workspaces / move active window (Lua loop replaces 20 individual binds)
for i = 1, 9 do
    hl.bind(mainMod .. " + " .. i,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. i, hl.dsp.exec_cmd("hyprctl dispatch movetoworkspace " .. i))
end
hl.bind(mainMod .. " + 0",           hl.dsp.focus({ workspace = 10 }))
hl.bind(mainMod .. " + SHIFT + 0",   hl.dsp.exec_cmd("hyprctl dispatch movetoworkspace 10"))

-- Cycle adjacent workspaces
hl.bind(mainMod .. " + CTRL + right",       hl.dsp.focus({ workspace = "r+1" }))
hl.bind(mainMod .. " + CTRL + left",        hl.dsp.focus({ workspace = "r-1" }))

-- Move active window to adjacent workspace
hl.bind(mainMod .. " + CTRL + ALT + right", hl.dsp.window.move({ workspace = "r+1" }))
hl.bind(mainMod .. " + CTRL + ALT + left",  hl.dsp.window.move({ workspace = "r-1" }))

-- Special workspace (scratchpad)
hl.bind(mainMod .. " + S",           hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S",   hl.dsp.exec_cmd("hyprctl dispatch movetoworkspace special:magic"))

-- Scroll through workspaces with mouse wheel
hl.bind(mainMod .. " + mouse_down",  hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",    hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mouse drag (bindm equivalent)
hl.bind(mainMod .. " + mouse:272",   hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273",   hl.dsp.window.resize(), { mouse = true })

-- Multimedia / volume keys (bindel: locked + repeating)
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),  { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),       { locked = true, repeating = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),      { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),    { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                   { locked = true, repeating = true })

-- Media controls (bindl: locked)
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),        { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"),  { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"),  { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),    { locked = true })

-- Hyprpicker
hl.bind(mainMod .. " + SHIFT + P",   hl.dsp.exec_cmd("hyprpicker -a"))

-- Notification center
hl.bind(mainMod .. " + N",           hl.dsp.exec_cmd("swaync-client -t"))

-- Wallpaper picker
hl.bind(mainMod .. " + W",           hl.dsp.exec_cmd(os.getenv("HOME") .. "/.config/hypr/scripts/wallpaper-picker.sh"))

-- Quick toggles
hl.bind(mainMod .. " + T",           hl.dsp.exec_cmd(os.getenv("HOME") .. "/.config/hypr/scripts/quicktoggles.sh"))

-- Screenshot
hl.bind(mainMod .. " + ALT + S",     hl.dsp.exec_cmd(os.getenv("HOME") .. "/.config/hypr/scripts/hyprshot.sh"))
