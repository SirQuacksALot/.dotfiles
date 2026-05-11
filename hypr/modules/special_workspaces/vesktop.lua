--
--             へ  ♡
--         ૮ >  <)
--         / ⁻ ៸|         Vesktop Special Workspace
--      乀(ˍ,ل ل
--
-- ---------------------------------------------------------------------------------
--
-- Vesktop (Discord) Special Workspace
--

local class = "vesktop"

hl.on("hyprland.start", function()
    hl.exec_cmd("vesktop")
end)

hl.window_rule({ match = { class = class },                                          workspace      = "special:" .. class .. " silent" })
hl.window_rule({ match = { class = class },                                          fullscreen     = true })
hl.window_rule({ match = { class = class },                                          suppress_event = "fullscreen" })
hl.window_rule({ match = { workspace = "special:" .. class, class = "^(?!" .. class .. ").*$" }, workspace = "previous" })

hl.bind("SUPER + SHIFT + D", hl.dsp.workspace.toggle_special(class))

hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 4, bezier = "easeOutQuint", style = "slidevert" })
