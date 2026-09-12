pragma Singleton
import QtQuick
import Quickshell.Hyprland

Item {



    readonly property var monitors:    Hyprland.monitors
    readonly property var workspaces:  Hyprland.workspaces
    readonly property var toplevels:   Hyprland.toplevels

    readonly property var focusedWorkspace: Hyprland.focusedWorkspace
    readonly property var activeToplevel:   Hyprland.activeToplevel



    function sortedWorkspaces() {
        var src = Hyprland.workspaces ? Hyprland.workspaces.values : []
        var out = []
        for (var i = 0; i < src.length; i++) out.push(src[i])
        out.sort(function(a, b) { return a.id - b.id })
        return out
    }

    function switchWorkspace(id) {
        Hyprland.dispatch("workspace " + id)
    }
}