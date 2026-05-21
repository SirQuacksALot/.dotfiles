--
--             へ  ♡
--         ૮ >  <)
--         / ⁻ ៸|         Obsidian Special Workspace
--      乀(ˍ,ل ل
--
-- ---------------------------------------------------------------------------------
--
-- Obsidian Special Workspace
--

local class = "obsidian"

hl.on("hyprland.start", function()
    hl.exec_cmd("obsidian")
end)

hl.window_rule({ match = { class = class },                                          workspace      = "special:" .. class .. " silent" })
hl.window_rule({ match = { class = class },                                          fullscreen     = true })
hl.window_rule({ match = { class = class },                                          suppress_event = "fullscreen" })
hl.window_rule({ match = { workspace = "special:" .. class, class = "^(?!" .. class .. ").*$" }, workspace = "previous" })

hl.bind("SUPER + SHIFT + N", hl.dsp.workspace.toggle_special(class))

hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 4, bezier = "easeOutQuint", style = "slidevert" })
