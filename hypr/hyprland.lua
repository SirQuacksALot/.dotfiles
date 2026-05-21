--
-- ⠀⠀⠀⠀⠀⠀⢀⣿⡀⠀⠀⠀⠀⠀⠀⠀⠀
-- ⠀⠀⠀⠀⠀⢀⣾⣿⡇⠀⠀⠀⠀⠀⢀⣼⡇
-- ⠀⠀⠀⠀⠀⣸⣿⣿⡇⠀⠀⠀⠀⣴⣿⣿⠃
-- ⠀⠀⠀⠀⢠⣿⣿⣿⣇⠀⠀⢀⣾⣿⣿⣿⠀
-- ⠀⠀⠀⣴⣿⣿⣿⣿⣿⣿⣷⣿⣿⣿⣿⡟⠀        Welcome to SirQuacksALot's Hyprland
-- ⠀⠀⢰⡿⠉⠀⡜⣿⣿⣿⡿⠿⢿⣿⣿⠃⠀                   Configuration
-- ⠒⠒⠸⣿⣄⡘⣃⣿⣿⡟⢰⠃⠀⢹⣿⡇⠀
-- ⠚⠉⠀⠈⠻⣿⣿⣿⣿⣿⣮⣤⣤⣿⡟⠁⠀
-- ⠀⠀⠀⠀⠀⠀⠈⠙⠛⠛⠛⠛⠛⠁⠀⠒⠤
-- ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠑⠀⠀
-- ---------------------------------------------------------------------------------
--
-- Wiki: https://wiki.hypr.land/Configuring/
--

-- -----------------------------------------------------------
-- Base configs: general and system-based settings
--

require("modules.display_settings")
require("modules.env_vars")
require("modules.programs")
require("modules.auto_start")
require("modules.input_devices")
require("modules.permissions")

-- -----------------------------------------------------------
-- Look, feel and control configs
--

require("modules.key_binds")
require("modules.style")
require("modules.window_rules")

-- -----------------------------------------------------------
-- Special Workspaces
--

require("modules.special_workspaces.vesktop")
require("modules.special_workspaces.zen_browser")
require("modules.special_workspaces.obsidian")

-- -----------------------------------------------------------
-- Monitor configuration (system-specific)
-- Hyprland Monitor Manager handles dynamic display/lid management
-- -----------------------------------------------------------

hl.monitor({ output = "eDP-1", mode = "1920x1200@59.95", position = "1920x-32", scale = 1.0 })
hl.monitor({ output = "DP-3",  mode = "1920x1200@59.95", position = "0x-32",    scale = 1.0 })
