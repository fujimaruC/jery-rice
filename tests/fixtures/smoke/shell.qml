import Quickshell
import QtQuick




ShellRoot {
    PanelWindow {
        anchors {
            top: true
            right: true
        }
        implicitWidth: 120
        implicitHeight: 24
        color: "#0d0e11"

        Text {
            text: "JERI"
            anchors.centerIn: parent
            color: "#7aa2f7"
            font.pixelSize: 12
            font.bold: true
        }
    }

    Timer {
        interval: 1500
        running: true
        repeat: false
        onTriggered: Qt.quit()
    }
}