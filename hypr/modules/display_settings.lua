--
--             へ  ♡
--         ૮ >  <)
--         / ⁻ ៸|         Display settings configurations
--      乀(ˍ,ل ل
--
-- ---------------------------------------------------------------------------------
--
-- Display settings configurations
-- See https://wiki.hypr.land/Configuring/Monitors/
--

-- Fallback rule for any monitor not explicitly configured
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })

hl.config({
    xwayland = {
        force_zero_scaling = true
    }
})
