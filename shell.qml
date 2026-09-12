import Quickshell
import QtQuick
import "./comp"
ShellRoot {
    PanelWindow { width: 100; height: 50; color: "transparent"; Card {} }
    Timer { interval: 800; running: true; onTriggered: Qt.quit() }
}
