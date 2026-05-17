#!/usr/bin/env python3
# Erstellt einen Wayland zwp_idle_inhibitor_v1 — selbes Protokoll wie waybar
import gi
gi.require_version('Gtk', '4.0')
from gi.repository import Gtk, GLib
import signal, sys

app = Gtk.Application(application_id="de.sebas.idle-inhibitor")

def on_activate(a):
    win = Gtk.ApplicationWindow(application=a, visible=False)
    a.inhibit(win, Gtk.ApplicationInhibitFlags.IDLE, "Manual")
    # Auf SIGTERM warten zum Beenden
    GLib.unix_signal_add(GLib.PRIORITY_DEFAULT, signal.SIGTERM, lambda: a.quit() or True)

app.connect("activate", on_activate)
sys.exit(app.run([]))
