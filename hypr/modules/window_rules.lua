--
--             へ  ♡
--         ૮ >  <)
--         / ⁻ ៸|         Window / Workspace rules configurations
--      乀(ˍ,ل ل
--
-- ---------------------------------------------------------------------------------
--
-- Window / Workspace rules configurations
-- See https://wiki.hypr.land/Configuring/Window-Rules/
-- See https://wiki.hypr.land/Configuring/Workspace-Rules/
--

hl.window_rule({
    name           = "suppress-maximize-events",
    match          = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    -- Fix dragging issues with XWayland windows
    name        = "fix-xwayland-drags",
    match       = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false },
    no_focus    = true,
})

hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },
    move  = "20 monitor_h-120",
    float = true,
})

hl.layer_rule({
    name      = "rofi-animation",
    match     = { namespace = "rofi" },
    animation = "popin 80%",
})

hl.layer_rule({
    name      = "swaync-control-center",
    match     = { namespace = "swaync-control-center" },
    animation = "slide right",
})

hl.layer_rule({
    name      = "swaync-notifications",
    match     = { namespace = "swaync-notification" },
    animation = "slide right",
})
