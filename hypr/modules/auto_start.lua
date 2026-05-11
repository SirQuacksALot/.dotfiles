--
--             へ  ♡
--         ૮ >  <)
--         / ⁻ ៸|         Auto start configurations
--      乀(ˍ,ل ل
--
-- ---------------------------------------------------------------------------------
--
-- Auto start configurations
-- See https://wiki.hypr.land/Configuring/Keywords/
--
-- hl.on("hyprland.start", ...) = exec-once (runs once on initial start)
-- hl.exec_cmd(...) at module level = exec (runs on every reload)
--

hl.on("hyprland.start", function()
    -- Pass session instance information to systemd user environment
    hl.exec_cmd("systemctl --user import-environment HYPRLAND_INSTANCE_SIGNATURE WAYLAND_DISPLAY XDG_RUNTIME_DIR DISPLAY DBUS_SESSION_BUS_ADDRESS")
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY HYPRLAND_INSTANCE_SIGNATURE")

    -- Polkit agent
    hl.exec_cmd("systemctl --user start hyprpolkitagent")

    -- Wallpaper daemon
    hl.exec_cmd("hyprpaper")

    -- Plugin manager (slight delay to allow Hyprland to settle)
    hl.exec_cmd("sleep 1 & hyprpm reload")

    -- Additional startup scripts
    hl.exec_cmd(os.getenv("HOME") .. "/.config/hypr/autostart.sh")

    -- Monitor manager daemon
    hl.exec_cmd("hmonitor daemon")

    -- Window switcher daemon
    hl.exec_cmd("snappy-switcher --daemon")
end)

-- Apply theming on every reload (exec equivalent)
-- For libadwaita GTK4 apps:
hl.exec_cmd('gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"')
-- For GTK3 apps (requires adw-gtk3 / adw-gtk-theme package):
hl.exec_cmd('gsettings set org.gnome.desktop.interface gtk-theme "adw-gtk3"')
