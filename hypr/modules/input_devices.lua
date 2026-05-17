--
--             へ  ♡
--         ૮ >  <)
--         / ⁻ ៸|         Input devices configurations
--      乀(ˍ,ل ل
--
-- ---------------------------------------------------------------------------------
--
-- Input devices configurations
-- https://wiki.hypr.land/Configuring/Variables/#input
--

hl.config({
    gestures = {
        scrolling = {
            move_snap_to_grid  = true,  -- snap to column grid on release
            move_snap_cursor   = true,  -- snap cursor to focused window on release
        }
    },

    input = {
        kb_layout  = "de",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        follow_mouse = 1,
        sensitivity  = 0,  -- -1.0 to 1.0, 0 = no modification

        touchpad = {
            natural_scroll  = true,
            drag_lock       = true,   -- double-tap then drag; drag persists after finger lift
        }
    }
})

-- 3-finger swipe: native scroll_move for the scrolling layout
-- Tracks 1:1 with finger movement (synchronous), unlike layoutmsg which fires on release
hl.gesture({ fingers = 3, direction = "horizontal", action = "scroll_move" })
hl.gesture({ fingers = 4, direction = "horizontal", action = "workspace" })

-- Per-device overrides
hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5
})
