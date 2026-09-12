pragma Singleton
import QtQuick
import "../theme"



Item {
    property int visualMode: Motion.Balanced
    property bool reducedMotion: false
    property bool dnd: false

    function toggleDnd() { dnd = !dnd }
    function cycleVisualMode() {
        visualMode = visualMode === Motion.Full ? Motion.Balanced
            : (visualMode === Motion.Balanced ? Motion.Lite : Motion.Full)
    }
}