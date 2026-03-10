#!/bin/bash

# Konfiguration
VM_NAME="linux2024"
VIRSH_URI="qemu:///system"
MAX_WAIT=120  # Maximale Wartezeit in Sekunden

# Prüfe ob virt-viewer bereits läuft
is_viewer_running() {
    pgrep -f "virt-viewer.*$VM_NAME" > /dev/null
}

# Prüfe VM Status (funktioniert mit Deutsch und Englisch)
vm_status=$(virsh -c "$VIRSH_URI" domstate "$VM_NAME" 2>/dev/null)

# Fall 1: VM läuft UND virt-viewer läuft bereits
if { [ "$vm_status" = "running" ] || [ "$vm_status" = "laufend" ]; } && is_viewer_running; then
    # Nur Passthrough-Mode aktivieren, nichts weiter tun
    hyprctl dispatch submap Passthrough
    exit 0
fi

# Fall 2: VM läuft, aber virt-viewer läuft NICHT
if [ "$vm_status" = "running" ] || [ "$vm_status" = "laufend" ]; then
    notify-send "VM bereits aktiv" "Verbinde mit $VM_NAME..."
    
    # KEIN Workspace-Wechsel - wird vom Keybind gemacht
    # Kleine Pause damit Workspace-Wechsel fertig ist
    sleep 1
    
    # Öffne virt-viewer im Fenstermodus (Hyprland macht fullscreen)
    virt-viewer --connect "$VIRSH_URI" --attach --wait "$VM_NAME" &
    
    # Warte bis virt-viewer Fenster erscheint
    sleep 2
    
    # Mache das Fenster fullscreen in Hyprland
    hyprctl dispatch fullscreen 0
    
    # Passthrough aktivieren
    sleep 1
    hyprctl dispatch submap Passthrough
    exit 0
fi

# Fall 3: VM läuft nicht - starten und warten
notify-send "VM-Start" "$VM_NAME wird gestartet..."

# Starte VM (ignoriere Fehler falls sie bereits läuft)
virsh -c "$VIRSH_URI" start "$VM_NAME" 2>/dev/null
start_result=$?

# Prüfe nochmal den Status
vm_status=$(virsh -c "$VIRSH_URI" domstate "$VM_NAME" 2>/dev/null)

if [ "$vm_status" != "running" ] && [ "$vm_status" != "laufend" ]; then
    notify-send -u critical "VM-Start Fehler" "Konnte $VM_NAME nicht starten (Status: $vm_status)"
    exit 1
fi

# Warte auf Guest Agent (Boot-Completion)
notify-send "VM bootet" "Warte auf vollständigen Boot..."

elapsed=0
while [ $elapsed -lt $MAX_WAIT ]; do
    # Teste Guest Agent Ping
    if virsh -c "$VIRSH_URI" qemu-agent-command "$VM_NAME" '{"execute":"guest-ping"}' --timeout 2 &>/dev/null; then
        notify-send "VM bereit" "$VM_NAME ist gestartet"
        sleep 1  # Kurze Pause für Stabilität
        break
    fi
    
    sleep 2
    elapsed=$((elapsed + 2))
done

if [ $elapsed -ge $MAX_WAIT ]; then
    notify-send -u critical "VM-Timeout" "$VM_NAME hat nicht rechtzeitig geantwortet"
    exit 1
fi

# KEIN Workspace-Wechsel - wird vom Keybind gemacht
# Kleine Pause damit Workspace-Wechsel fertig ist
sleep 1

# Öffne virt-viewer im Fullscreen
virt-manager --connect "$VIRSH_URI" --attach --wait --kiosk "$VM_NAME" &
    # Mache das Fenster fullscreen in Hyprland
    hyprctl dispatch fullscreen 0

# Passthrough aktivieren
sleep 1
hyprctl dispatch submap Passthrough